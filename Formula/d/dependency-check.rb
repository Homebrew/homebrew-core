class DependencyCheck < Formula
  desc "OWASP dependency-check"
  homepage "https://owasp.org/www-project-dependency-check/"
  url "https://github.com/jeremylong/DependencyCheck/releases/download/v9.2.0/dependency-check-9.2.0-release.zip"
  sha256 "dd453ebff45b8e1582fc29f147c95d539f7283b760678375b9e666cb1fc1b603"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dependency-check[._-]v?(\d+(?:\.\d+)+)-release\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d664c124e527b4680e75f1a2ea137254b5ebea88f9ccae364b07a4b479f554ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5023f9ee61f7bd5464ad96b186d2bff7b97ccf19f123f6f3698638fa4ca79b67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d58c810dab7ae48d9c06c0c5e91e993614b1f0aced849c6fc9e9e9cad461832"
    sha256 cellar: :any_skip_relocation, sonoma:         "72d568f9fab8db606f6902c98a47d4e37f5fcfb9a605646fd97ad256932c6c1d"
    sha256 cellar: :any_skip_relocation, ventura:        "c82ba12c679ffcdb57e85d4594403e3f189e02bd1b4a72e16b2fe74803abeba4"
    sha256 cellar: :any_skip_relocation, monterey:       "848372bc3644d7167c4c2cec7e918f0fd7449e20af10011a5d2c2f5b205edc94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31d0a3cf755f0b3c84aa90d4bbdd573b94689e74974c695d92f4c14eba5def92"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]

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
