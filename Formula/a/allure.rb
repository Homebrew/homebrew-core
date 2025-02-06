class Allure < Formula
  desc "Flexible lightweight test report tool"
  homepage "https://github.com/allure-framework/allure2"
  url "https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.32.2/allure-commandline-2.32.2.zip"
  sha256 "3f28885e2118f6317c92f667eaddcc6491400af1fb9773c1f3797a5fa5174953"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/qameta/allure/allure-commandline/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "df59139558e068f815a7f28ba4cef6fa3f99603f08d433aaeca5066dbe784d43"
  end

  depends_on "openjdk"

  def install
    # Remove all windows files
    rm(Dir["bin/*.bat"])

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    (testpath/"allure-results/allure-result.json").write <<~JSON
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
    JSON
    system bin/"allure", "generate", "#{testpath}/allure-results", "-o", "#{testpath}/allure-report"
  end
end
