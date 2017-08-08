class Allure < Formula
  desc "Flexible lightweight test report tool"
  homepage "https://github.com/allure-framework/allure2"
  url "https://dl.bintray.com/qameta/generic/io/qameta/allure/allure/2.3.3/allure-2.3.3.zip"
  sha256 "f625663d0aa932edd8633b99c761954eb10584e6f92800b5e895cd47243b0389"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    # Remove all windows files
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"allure-results/allure-result.json").write <<-EOS.undent
    {
      "uuid": "allure",
      "name": "testReportGeneration",
      "fullName": "org.homebrew.AllureFormula.testReportGeneration",
      "status": "passed",
      "stage": "finished",
      "start": 1494857300486,
      "stop": 1494857300492,
      "labels": [
        {
          "name": "package",
          "value": "org.homebrew"
        },
        {
          "name": "testClass",
          "value": "AllureFormula"
        },
        {
          "name": "testMethod",
          "value": "testReportGeneration"
        }
      ]
    }
    EOS
    system "#{bin}/allure", "generate", "#{testpath}/allure-results", "-o", "#{testpath}/allure-report"
  end
end
