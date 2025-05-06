class DependencyCheck < Formula
  desc "OWASP dependency-check"
  homepage "https://owasp.org/www-project-dependency-check/"
  url "https://github.com/dependency-check/DependencyCheck/releases/download/v12.1.1/dependency-check-12.1.1-release.zip"
  sha256 "4511a2f1b4b5f8fc98fbd64c7455a9e49c6f89b5a74977d3eaa84a141c07e43a"
  license "Apache-2.0"
  head "https://github.com/dependency-check/DependencyCheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "05d697ff1d8f7c04ad642c3ba24511eeaa0c2e4a071ad62e32eb032d8dea3eb9"
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
              "--nvdDatafeed", "https://dependency-check.github.io/DependencyCheck/hb_nvd/",
              "--disableKnownExploited"
    assert_path_exists testpath/"dependency-check-report.xml"
  end
end
