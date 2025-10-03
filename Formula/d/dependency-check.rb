class DependencyCheck < Formula
  desc "OWASP dependency-check"
  homepage "https://owasp.org/www-project-dependency-check/"
  url "https://github.com/dependency-check/DependencyCheck/releases/download/v12.1.6/dependency-check-12.1.6-release.zip"
  sha256 "1d8a60e379099e33009d2d105daa9f52b27f4ac5dc1859a279c76fbc2096c2ed"
  license "Apache-2.0"
  head "https://github.com/dependency-check/DependencyCheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d12e7bcac16f04fed5ede22eae340ddadc03df15e3800cdddc9da25e2714623d"
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
    output = shell_output("#{bin}/dependency-check --version")
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
              "--disableKnownExploited",
              "--disableOssIndex" # disable oss index due to username/password requirement
    assert_path_exists testpath/"dependency-check-report.xml"
  end
end
