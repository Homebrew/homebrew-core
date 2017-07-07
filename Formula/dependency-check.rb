class DependencyCheck < Formula
  desc "OWASP Dependency Check"
  homepage "https://www.owasp.org/index.php/OWASP_Dependency_Check"
  url "https://dl.bintray.com/jeremy-long/owasp/dependency-check-2.0.1-release.zip"
  version "2.0.1"
  sha256 "eb7af1bf9122b37bb369f4a28250f6889b91395e864b55eb7b9ba7a01437b204"

  bottle :unneeded

  depends_on :java

  def install
    rm_f Dir["bin/*.bat"]

    chmod 0755, "bin/dependency-check.sh"
    libexec.install Dir["*"]

    mv libexec/"bin/dependency-check.sh", libexec/"bin/dependency-check"
    bin.install_symlink libexec/"bin/dependency-check"

    (var/"dependencycheck").mkpath
    libexec.install_symlink var/"dependencycheck" => "data"

    (etc/"dependencycheck").mkpath
    jar = "dependency-check-core-#{version}.jar"
    corejar = libexec/"repo/org/owasp/dependency-check-core/#{version}/#{jar}"
    system "unzip", "-o", corejar, "dependencycheck.properties", "-d", libexec/"etc"
    (etc/"dependencycheck").install_symlink libexec/"etc/dependencycheck.properties"
  end

  test do
    output = shell_output("#{libexec}/bin/dependency-check --version").strip
    assert_match "Dependency-Check Core version #{version}", output

    (testpath/"temp-props.properties").write <<-EOS.undent
      cve.startyear=2017
      analyzer.assembly.enabled=false
    EOS
    system bin/"dependency-check", "-P", "temp-props.properties", "-f", "XML",
               "--project", "dc", "-s", libexec, "-d", testpath, "-o", testpath
    assert File.exist?(testpath/"dependency-check-report.xml")
  end
end
