class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "https://forge.jboss.org/"
  url "https://downloads.jboss.org/forge/releases/3.6.0.Final/forge-distribution-3.6.0.Final-offline.zip"
  version "3.6.0.Final"
  sha256 "e7093b7beef94031d00c771306aeccf69a15d45029de92bef51d8b3c3ab3af9d"

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
