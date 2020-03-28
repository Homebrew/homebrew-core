class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "https://forge.jboss.org/"
  url "https://downloads.jboss.org/forge/releases/3.9.7.Final/forge-distribution-3.9.7.Final-offline.zip"
  sha256 "d9ed822e48ef40147ef3e33d3c5998f027109f4d901d809065503f86076f4bbf"

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[addons bin lib logging.properties]
    bin.install libexec/"bin/forge"
    bin.env_script_all_files libexec/"bin", :JAVA_HOME => "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
  end

  test do
    assert_match "org.jboss.forge.addon:core", shell_output("#{bin}/forge --list")
  end
end
