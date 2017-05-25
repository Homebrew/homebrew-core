class ApacheCtakes < Formula
  desc "NLP system for extraction of information from EMR clinical text."
  homepage "https://ctakes.apache.org"
  url "https://apache.osuosl.org/ctakes/ctakes-4.0.0/apache-ctakes-4.0.0-bin.tar.gz"
  sha256 "37ca2b8dfe06465469ed1830fbb84dfc7bcc4295e5387d66e90a76ad2a5cdeaf"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    rm_f Dir["bin/*.bat", "bin/*.cmd", "bin/ctakes.profile", "bin/ctakes-ytex", "libexec/*.bat", "libexec/*.cmd"]
    libexec.install %w[bin config desc lib resources]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"notes.txt").write <<-EOS.undent
      Dr. Nutritious

      Medical Nutrition Therapy for Hyperlipidemia

      Referral from: Julie Tester, RD, LD, CNSD
      Phone contact: (555) 555-1212
      Height: 144 cm   Current Weight: 45 kg   Date of current weight:
      02-29-2001 Admit Weight:  53 kg   BMI: 18 kg/m2
      Diet: General
      Daily Calorie needs (kcals): 1500 calories, assessed as HB + 20%
      for activity.
      Daily Protein needs: 40 grams,  assessed as 1.0 g/kg.
      Pt has been on a 3-day calorie count and has had an average
      intake of 1100 calories.  She was instructed to drink 2-3 cans
      of liquid supplement to help promote weight gain.  She agrees
      with the plan and has my number for further assessment. May want
      a Resting Metabolic Rate as well. She takes an aspirin a day for
      knee pain.
    EOS
    system "#{bin}/runPiperFile.sh", "-p", "#{libexec}/resources/org/apache/ctakes/examples/pipeline/HelloWorld.piper", "-i", "#{testpath}/notes.txt"
  end
end
