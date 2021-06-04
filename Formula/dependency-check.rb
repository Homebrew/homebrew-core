class DependencyCheck < Formula
  desc "OWASP dependency-check"
  homepage "https://owasp.org/www-project-dependency-check/"
  url "https://github.com/jeremylong/DependencyCheck/releases/download/v6.2.0/dependency-check-6.2.0-release.zip"
  sha256 "d723467049d0d23e7e3230baf47cf56243b76aea86c6cadbfdb20c22b01b9223"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dependency-check[._-]v?(\d+(?:\.\d+)+)-release\.zip/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "737193a21954c8e17ee6cceba9fe5feb428539ae8a049dde766a7216a1aafbb4"
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
    output = shell_output("#{bin}/dependency-check --version").strip
    assert_match "Dependency-Check Core version #{version}", output

    (testpath/"temp-props.properties").write <<~EOS
      cve.startyear=2017
      analyzer.assembly.enabled=false
    EOS
    system bin/"dependency-check", "-P", "temp-props.properties", "-f", "XML",
               "--project", "dc", "-s", libexec, "-d", testpath, "-o", testpath
    assert_predicate testpath/"dependency-check-report.xml", :exist?
  end
end
