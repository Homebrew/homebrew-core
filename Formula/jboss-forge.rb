class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "https://forge.jboss.org/"
  url "https://downloads.jboss.org/forge/releases/3.6.1.Final/forge-distribution-3.6.1.Final-offline.zip"
  version "3.6.1.Final"
  sha256 "1ca6b26776a0d34670b662c1b262f3c723cea3ad945fe26582768c0d0e407b7a"

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
