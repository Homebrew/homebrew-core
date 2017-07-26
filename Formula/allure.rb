class Allure < Formula
  desc "Flexible lightweight test report tool"
  homepage "https://github.com/allure-framework/allure2"
  url "https://dl.bintray.com/qameta/generic/io/qameta/allure/allure/2.3/allure-2.3.zip"
  sha256 "3c13eaeba5d936c11ec824c2b93958c06ba3c85acf28b5fd19ac3ee63e4ca7bd"

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
