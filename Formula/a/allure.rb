class Allure < Formula
  desc "Flexible lightweight test report tool"
  homepage "https://allurereport.org/"
  url "https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.45.0/allure-commandline-2.45.0.zip"
  sha256 "a0a840979b6d212e9eee031563d669985eb353cfde60557343b2903bf08570a6"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/qameta/allure/allure-commandline/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a49babf1cbf1ee89ec34817e9944dd39036c8d57f53191b607541b7c9d6c7eca"
  end

  depends_on "openjdk"

  def install
    # Remove all windows files
    rm(Dir["bin/*.bat"])

    libexec.install Dir["*"]
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files libexec/"bin", JAVA_HOME: formula_opt_prefix("openjdk")
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
    system bin/"allure", "generate", testpath/"allure-results", "-o", testpath/"allure-report"
  end
end
