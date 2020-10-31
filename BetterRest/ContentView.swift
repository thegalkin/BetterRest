//
//  ContentView.swift
//  BetterRest
//
//  Created by Никита Галкин on 27.10.2020.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = Date()
	@State private var sleepAmount = 8.0
	@State private var coffeAmount = 1
	
	@State private var alertTitle = ""
	@State private var alertMessage = ""
	@State private var showingAlert = false
	
    var body: some View {
		NavigationView{
			
			VStack{
				Spacer()
			Text("When do you what to wake up?").font(.headline)
			
				DatePicker("Please select a time", selection: $wakeUp, displayedComponents: .hourAndMinute).labelsHidden()
				Spacer()
				Text("Desired Amount of Sleep")
					.font(.headline)
				HStack{
					Stepper(value: $sleepAmount, in: 3...15, step: 0.5){
					Text("\(sleepAmount, specifier: "%g") hours")
				}.frame(width: 200, height: 5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
				}
				Spacer()
				Text("Daily coffe intake")
					.font(.headline)
				HStack{
					Stepper(value: $coffeAmount, in: 1...20, step: 1){
						if (coffeAmount == 1){
							Text("\(coffeAmount) cup")
						}else{
							Text("\(coffeAmount ) cups")}
					}.frame(width: 200, height: 5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
				}
		Spacer()
			}.navigationBarTitle("BetterRest")
				.navigationBarItems(trailing:
										Button(action: calculateBedTime) {
											Text("Calculate")
										}
				)
			
		}
		
        
		.alert(isPresented: $showingAlert, content: {
			Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
		})
        
    }
	func calculateBedTime(){
		let model = SleepCalculator()
		let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
		let hour = (components.hour ?? 0) * 60 * 60
		let minute = (components.minute ?? 0) * 60
		do{
			let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeAmount))
			let sleepTime = wakeUp - prediction.actualSleep
			let formatter = DateFormatter()
			formatter.timeStyle = .short
			
			alertMessage = formatter.string(from: sleepTime)
			alertTitle = "Your ideal bedtime is..."
		}catch{
			alertTitle = "Error"
			alertMessage = "Something in your prediction went wrong, please try again"
		}
		showingAlert = true
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
			.previewDevice("iPhone SE (2nd generation)")
    }
}
