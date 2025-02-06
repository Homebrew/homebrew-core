class DependencyCheck < Formula
  desc "OWASP dependency-check"
  homepage "https://owasp.org/www-project-dependency-check/"
  url "https://github.com/jeremylong/DependencyCheck/releases/download/v12.0.2/dependency-check-12.0.2-release.zip"
  sha256 "ca9f1ab7aef4f7bde3ca7b228edae74c4933e4dbbcfb1beb457261c925985c3e"
  license "Apache-2.0"
  head "https://github.com/jeremylong/DependencyCheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "83b013f81a622e586020fc8418b53b1f908a6a9d69c64a65b6dbf77819cf500b"
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
