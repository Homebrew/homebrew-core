class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "https://forge.jboss.org/"
  url "https://downloads.jboss.org/forge/releases/3.2.1.Final/forge-distribution-3.2.1.Final-offline.zip"
  version "3.2.1.Final"
  sha256 "91ac6876f04c2f0b27064e0fa619c7ab059366d0b5999118db2200c065867295"

  bottle :unneeded

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[addons bin lib logging.properties]
    bin.install_symlink libexec/"bin/forge"
  end

  test do
    ENV["FORGE_OPTS"] = "-Duser.home=#{testpath}"
    assert_match "org.jboss.forge.addon:core", shell_output("#{bin}/forge --list")
  end
end
