class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "https://forge.jboss.org/"
  url "https://downloads.jboss.org/forge/releases/3.9.6.Final/forge-distribution-3.9.6.Final-offline.zip"
  version "3.9.6.Final"
  sha256 "a9b20cb25f8d8009a6cb3c7419842c2594ee05cc4af42c26753afdd283148960"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[addons bin lib logging.properties]
    bin.install_symlink libexec/"bin/forge"
  end

  test do
    assert_match "org.jboss.forge.addon:core", shell_output("#{bin}/forge --list")
  end
end
