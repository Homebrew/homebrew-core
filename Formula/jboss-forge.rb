class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "https://forge.jboss.org/"
  url "https://downloads.jboss.org/forge/releases/3.7.1.Final/forge-distribution-3.7.1.Final-offline.zip"
  version "3.7.1.Final"
  sha256 "1bcf79302356d702ea55d821ac603b01c17cd9fe65940f75a89e56ece60e5c93"

  bottle :unneeded
  depends_on :java=>"1.8+"

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
