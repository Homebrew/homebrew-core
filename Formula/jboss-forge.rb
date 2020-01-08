class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "https://forge.jboss.org/"
  url "https://downloads.jboss.org/forge/releases/3.9.5.Final/forge-distribution-3.9.5.Final-offline.zip"
  version "3.9.5.Final"
  sha256 "c4d7da26ea14ed3fe61aecb1f2a6341cbed20f9642a253cb95e6ea200c577126"

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
