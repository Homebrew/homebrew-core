class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "https://forge.jboss.org/"
  url "https://downloads.jboss.org/forge/releases/3.4.0.Final/forge-distribution-3.4.0.Final-offline.zip"
  version "3.4.0.Final"
  sha256 "8bdef0c8217a0f310b16599a6c97eb479a4a4627bf8c49cd5a8c061a1a18d422"

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
