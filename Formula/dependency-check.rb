class DependencyCheck < Formula
  desc "OWASP dependency-check"
  homepage "https://owasp.org/www-project-dependency-check/"
  url "https://github.com/jeremylong/DependencyCheck/releases/download/v8.1.2/dependency-check-8.1.2-release.zip"
  sha256 "4eebe807f955d930d8dad0ff4b57715ac2c8c98ef1e18c79c03af283b5ec95f4"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dependency-check[._-]v?(\d+(?:\.\d+)+)-release\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "08474455b027e1165b5d0b3b3c971f23fc25d067c66775d0f27d2e885b87f76e"
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
               "--cveUrlBase", "https://jeremylong.github.io/DependencyCheck/hb_nvd/nvdcve-1.1-%d.json.gz",
               "--cveUrlModified", "https://jeremylong.github.io/DependencyCheck/hb_nvd/nvdcve-1.1-modified.json.gz",
               "--cveStartYear", Time.now.year, "--cveDownloadWait", "5000", "--disableKnownExploited"
    assert_predicate testpath/"dependency-check-report.xml", :exist?
  end
end
