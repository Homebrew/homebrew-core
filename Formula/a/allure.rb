class Allure < Formula
  desc "Flexible lightweight test report tool"
  homepage "https://github.com/allure-framework/allure2"
  url "https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.30.0/allure-commandline-2.30.0.zip"
  sha256 "2e3e9af0772796862da17d95007abd8d3df1176c13aca89ee2c79118fe4dd2f7"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/qameta/allure/allure-commandline/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0dcc88d31dacc90ea42157fd33aeaf308bffc0d2ba821848435345f293c2f3d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0dcc88d31dacc90ea42157fd33aeaf308bffc0d2ba821848435345f293c2f3d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dcc88d31dacc90ea42157fd33aeaf308bffc0d2ba821848435345f293c2f3d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "0dcc88d31dacc90ea42157fd33aeaf308bffc0d2ba821848435345f293c2f3d4"
    sha256 cellar: :any_skip_relocation, ventura:        "0dcc88d31dacc90ea42157fd33aeaf308bffc0d2ba821848435345f293c2f3d4"
    sha256 cellar: :any_skip_relocation, monterey:       "0dcc88d31dacc90ea42157fd33aeaf308bffc0d2ba821848435345f293c2f3d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aba96abd6775fb70188e8f9cab54fd1ee362f184a99d891b3dc8a5e5901e4c37"
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
    system bin/"allure", "generate", "#{testpath}/allure-results", "-o", "#{testpath}/allure-report"
  end
end
