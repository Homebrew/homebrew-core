class DependencyCheck < Formula
  desc "OWASP dependency-check"
  homepage "https://owasp.org/www-project-dependency-check/"
  url "https://github.com/jeremylong/DependencyCheck/releases/download/v10.0.2/dependency-check-10.0.2-release.zip"
  sha256 "c8b6089911586a4d2b1044be42ba497bce248867cdddf90875aab9b5e39aad68"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dependency-check[._-]v?(\d+(?:\.\d+)+)-release\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d881dadcedc45d6dfff42e455763f511c282b4bdebb079aa0cae6b9c0f833ade"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d881dadcedc45d6dfff42e455763f511c282b4bdebb079aa0cae6b9c0f833ade"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d881dadcedc45d6dfff42e455763f511c282b4bdebb079aa0cae6b9c0f833ade"
    sha256 cellar: :any_skip_relocation, sonoma:         "d881dadcedc45d6dfff42e455763f511c282b4bdebb079aa0cae6b9c0f833ade"
    sha256 cellar: :any_skip_relocation, ventura:        "d881dadcedc45d6dfff42e455763f511c282b4bdebb079aa0cae6b9c0f833ade"
    sha256 cellar: :any_skip_relocation, monterey:       "d881dadcedc45d6dfff42e455763f511c282b4bdebb079aa0cae6b9c0f833ade"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82b3294dfedaedc0718e47dba90455b861113f5923e4f9a17a80186e691abd90"
  end

  depends_on "openjdk"

  def install
    rm(Dir["bin/*.bat"])

    chmod 0755, "bin/dependency-check.sh"
    libexec.install Dir["*"]

    (bin/"dependency-check").write_env_script libexec/"bin/dependency-check.sh",
      JAVA_HOME: Formula["openjdk"].opt_prefix

    (var/"dependencycheck").mkpath
    libexec.install_symlink var/"dependencycheck" => "data"

    (etc/"dependencycheck").mkpath
    jar = "dependency-check-core-#{version}.jar"
    corejar = libexec/"lib/#{jar}"
    system "unzip", "-o", corejar, "dependencycheck.properties", "-d", libexec/"etc"
    (etc/"dependencycheck").install_symlink libexec/"etc/dependencycheck.properties"
  end

  test do
    # wait a random amount of time as multiple tests are being on different OS
    # the sleep 1 seconds to 30 seconds assists with the NVD Rate Limiting issues
    sleep(rand(1..30))
    output = shell_output("#{bin}/dependency-check --version").strip
    assert_match "Dependency-Check Core version #{version}", output

    (testpath/"temp-props.properties").write <<~EOS
      cve.startyear=2017
      analyzer.assembly.enabled=false
      analyzer.dependencymerging.enabled=false
      analyzer.dependencybundling.enabled=false
    EOS
    system bin/"dependency-check", "-P", "temp-props.properties", "-f", "XML",
              "--project", "dc", "-s", libexec, "-d", testpath, "-o", testpath,
              "--nvdDatafeed", "https://jeremylong.github.io/DependencyCheck/hb_nvd/",
              "--disableKnownExploited"
    assert_predicate testpath/"dependency-check-report.xml", :exist?
  end
end
