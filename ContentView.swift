//
//  ContentView.swift
//  PS
//
//  Created by 游家和 on 2023/5/12.
//

import SwiftUI
import UIKit
import WebKit

struct ContentView: View {
    
    @State private var userAgreed = false
    @State private var userDisagreed = false
    @State private var showWebView1 = false

    
    var body: some View {
        NavigationView{
            VStack{
                Image("card")
                    .resizable()
                    .scaledToFit()
                GroupBox(label:
                            Label("隱私與安全同意政策", systemImage: "doc.on.clipboard.fill")
                    .font(.title2)
                ) {
                    ScrollView(.vertical, showsIndicators: true) {
                        Text("使用NFC行動支付服務將伴隨一定程度的\(Text("資料隱私").bold())與\(Text("資料安全").bold())風險，同時我們將積極管理您的資料隱私權與安全性，請詳讀以下政策內容，並慎重考慮是否同意使用此服務。")
                            .underline()
                            .font(.system(size: 15))
                        Spacer()
                        
                        Text("您的隱私資料將如何被管理")
                            .multilineTextAlignment(.center)
                            .fontWeight(.bold)
                        
                        
                        VStack{
                            Spacer()
                            Text("- 將卡片加入 NFC 行動支付服務時，該卡片的相關資訊、位置和裝置設定與使用模式的資訊都可能會傳送到行動裝置供應商來確認卡片是否適用。")
                            Spacer()
                            Text("- 可能會與你的發卡機構或銀行分享以上的部分資訊、與帳號相關的資訊和配對裝置的詳細資訊，以確認卡片的適用性並用於防範詐騙。")
                            Spacer()
                            Text("- 行動裝置供應商可能會使用已與你無關的 NFC 行動付款服務資料來改進服務。")
                        }.font(.subheadline)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        
                        Text("您的資料安全將如何被保障")
                            .multilineTextAlignment(.center)
                            .fontWeight(.bold)
                        
                        
                        VStack{
                            Spacer()
                            Text("- 生物辨識技術：NFC 行動支付服務可以選擇使用臉部與指紋辨識等生物辨識技術來授權支付，因此只有裝置持有者本人能夠被識別並進行支付。")
                            Spacer()
                            Text("- 密碼：NFC 行動支付服務可能要求使用者輸入裝置密碼以授權支付，且唯有裝置持有者知曉正確密碼組合。")
                            Spacer()
                            Text("- Secure Element(SE)：SE 備有一種特殊設計的小型應用程式(Applet)來管理 NFC 行動支付服務，其中也包含經過付款網路或發卡機構認證的 Applet。加密 Applet 的付款網路或發卡機構會使用密鑰來傳送信用卡、簽帳金融卡或預付卡資料，且只有付款網路或發卡機構和 Applet 的安全網域擁有密鑰的相關資訊。")
                            Spacer()
                            Text("- NFC 控制器：作為 Secure Element 的閘道，NFC 控制器會協助確保所有非接觸式付款交易均使用接近該裝置的銷售點終端機進行。只有感應範圍內的終端機所傳送的付款要求才會由 NFC 控制器標記為非接觸式付款交易。")
                        }.font(.subheadline)
                            .multilineTextAlignment(.leading)
                        
                    }
                    .frame(maxHeight: .infinity)
                    
                    Section{
                        Toggle(isOn: $userAgreed) {
                            Text("本人已閱讀、了解並同意上述政策條款")
                        }
                        
                        Button("不同意上述政策，並退出服務"){
                            userDisagreed = true
                        }.disabled(userAgreed==true)
                        
                    }.font(.system(size: 16, weight: .semibold))

                    
                    
//                    Toggle(isOn: $userDisagreed) {
//                        Text("本人不同意上述政策條款")
//                            .font(.system(size:15, weight: .semibold))
//                    }
                    
                    
                    //continueButton
                    //                    Button {
                    //
                    //                    } label: {
                    //                        Text("Continue")
                    //                            .fontWeight(.bold)
                    //                            .font(.system(.title, design: .rounded))
                    //                    }
                    //                    .padding()
                    //                    .foregroundColor(.white)
                    //                    .background(Color.blue)
                    //                    .cornerRadius(20)
                    //                     .controlSize(.large)
                    if userAgreed{
                        NavigationLink(destination: SecondView(), label: { Text("繼續")
                                .bold()
                                .font(.system(size: 25))
                                .frame(width: 100, height: 50)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        })
                    }
                    else if userDisagreed{
                        Button {
                            showWebView1.toggle()
                        } label: {
                            Text("前往問卷")
                        }
                        .bold()
                        .cornerRadius(15)
                        .buttonStyle(.borderedProminent)
                        .font(.system(size: 25))
                        .frame(width: 200, height: 50)
                        .sheet(isPresented: $showWebView1) {
                            WebView(url: URL(string: "https://www.surveycake.com/s/xx4nz")!)
                        }
                    }
                    
                }
            }.navigationTitle("同意政策")
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}

struct SecondView: View{
    @State private var name = "游家和"
    @State private var cardNumber = ""
    @State private var finishBox = false
    @Environment(\.presentationMode) var presentationMode
    @State private var showWebView = false
    @State private var done = false
    @FocusState private var keyboard : Bool
    
    
    
    var body: some View{
        VStack{
            Form{
                Section(header: Text("輸入並驗證您的卡片資訊")){
                    TextField("姓名", text: $name)
                    SecureField("卡號 共16碼", text: self.$cardNumber.max(16))
                        .keyboardType(.numberPad)
                        .focused($keyboard)
                }
            }
            if name != "" {
                if cardNumber.count == 16 {
                    Button("完成"){
                        self.finishBox = true
                        keyboard = false
                    }
                    .font(.system(size: 25))
                    .frame(width: 100, height: 50)
                    .alert(isPresented: $finishBox) {
                        Alert(
                            title: Text("卡片已成功加入裝置"),
                            dismissButton: .default(Text("確認")){
                                self.done = true
                                self.cardNumber = ""
                                self.name = ""
                                //                                self.presentationMode.wrappedValue.dismiss()
                            }
                            
                        )
                        
                    }
                    
                }
            }
            
            if done{
                Button {
                    showWebView.toggle()
                } label: {
                    Text("前往問卷")
                }
                .cornerRadius(15)
                .buttonStyle(.borderedProminent)
                .font(.system(size: 25))
                .frame(width: 200, height: 50)
                .sheet(isPresented: $showWebView) {
                    WebView(url: URL(string: "https://www.surveycake.com/s/ZPboG")!)
                }
            }
        }
        .navigationTitle("卡片資訊")
        
        //            .toolbar{
        //                    NavigationLink(destination: FinalView()) {
        //                        Text("完成")
        //                    }
        //            }
    }
}

//struct FinalView: View{
//    var body: some View{
//            Text("You are All Set!")
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .bold()
//                .font(.system(size: 36))
//                .background(.gray)
//    }
//}

//問卷
struct WebView: UIViewRepresentable {
    
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

//run the whole thing
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
