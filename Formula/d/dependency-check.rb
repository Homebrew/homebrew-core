class DependencyCheck < Formula
  desc "OWASP dependency-check"
  homepage "https://owasp.org/www-project-dependency-check/"
  url "https://github.com/dependency-check/DependencyCheck/releases/download/v13.0.0/dependency-check-13.0.0-release.zip"
  sha256 "44d920d1ec03e948df862a253f0912782a31b9beee8a7c8895b9cb95760176ed"
  license "Apache-2.0"
  head "https://github.com/dependency-check/DependencyCheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1afa418b76e8e058939c5136c6d9500d18ff892b85e83cbf129d0c6cc135a6cd"
  end

  depends_on "openjdk"

  def install
    rm(Dir["bin/*.bat"])

    chmod 0755, "bin/dependency-check.sh"
    libexec.install Dir["*"]

    (bin/"dependency-check").write_env_script libexec/"bin/dependency-check.sh",
      JAVA_HOME: formula_opt_prefix("openjdk")

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
    assert_match version.to_s, shell_output("#{bin}/dependency-check --version")

    (testpath/"temp-props.properties").write <<~EOS
      cve.startyear=2017
      analyzer.assembly.enabled=false
      analyzer.central.enabled=false
      analyzer.dependencymerging.enabled=false
      analyzer.dependencybundling.enabled=false
    EOS
    system bin/"dependency-check", "-P", "temp-props.properties", "-f", "XML",
              "--project", "dc", "-s", libexec, "-d", testpath, "-o", testpath,
              "--nvdDatafeed", "https://dependency-check.github.io/DependencyCheck/hb_nvd/",
              "--disableKnownExploited",
              "--disableOssIndex" # disable oss index due to username/password requirement
    assert_path_exists testpath/"dependency-check-report.xml"
  end
end
