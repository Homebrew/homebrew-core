class Allure < Formula
  desc "Flexible lightweight test report tool"
  homepage "https://github.com/allure-framework/allure2"
  url "https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.15.0/allure-commandline-2.15.0.zip"
  sha256 "bd8a90fa4badf1a9d005d000a0e1ae020bad8674d1085541478913d39741014e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "efb901aa364242ecfeec70d5949c5962efffbb6cfe2962aa6a13d627fb1b4116"
  end

  depends_on "openjdk"

  def install
    # Remove all windows files
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
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
