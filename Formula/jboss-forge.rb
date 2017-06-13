class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "https://forge.jboss.org/"
  url "https://downloads.jboss.org/forge/releases/3.7.0.Final/forge-distribution-3.7.0.Final-offline.zip"
  version "3.7.0.Final"
  sha256 "58c7d31861a7b79e7876d4ee2f856a75ff351f98a3f190460f4b16abe83f8cfa"

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
