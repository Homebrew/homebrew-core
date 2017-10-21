class Allure < Formula
  desc "Flexible lightweight test report tool"
  homepage "https://github.com/allure-framework/allure2"
  url "https://dl.bintray.com/qameta/generic/io/qameta/allure/allure/2.4.1/allure-2.4.1.zip"
  sha256 "8e84dd3dc664e79a0b8dd8c2d37a0c0ad0ecce91a8c7eec4da1bebed1f50897a"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    # Remove all windows files
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"allure-results/allure-result.json").write <<~EOS
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
