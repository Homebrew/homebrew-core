class Allure < Formula
  desc "Flexible lightweight test report tool"
  homepage "https://github.com/allure-framework/allure2"
  url "https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.23.1/allure-commandline-2.23.1.zip"
  sha256 "11141bfe727504b3fd80c0f9801eb317407fd0ac983ebb57e671f14bac4bcd86"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=io/qameta/allure/allure-commandline/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9f7b30d7c2fdc6ca76ba172e7b2d684a8681a7e5f97a3665ad967bcf6f0f614"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9f7b30d7c2fdc6ca76ba172e7b2d684a8681a7e5f97a3665ad967bcf6f0f614"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9f7b30d7c2fdc6ca76ba172e7b2d684a8681a7e5f97a3665ad967bcf6f0f614"
    sha256 cellar: :any_skip_relocation, ventura:        "c9f7b30d7c2fdc6ca76ba172e7b2d684a8681a7e5f97a3665ad967bcf6f0f614"
    sha256 cellar: :any_skip_relocation, monterey:       "c9f7b30d7c2fdc6ca76ba172e7b2d684a8681a7e5f97a3665ad967bcf6f0f614"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9f7b30d7c2fdc6ca76ba172e7b2d684a8681a7e5f97a3665ad967bcf6f0f614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa62088c68d7cfa0929ab137634a72666fa074c9d59fc8299ed52b86e6296b3a"
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
