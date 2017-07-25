class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "https://forge.jboss.org/"
  url "https://downloads.jboss.org/forge/releases/3.7.2.Final/forge-distribution-3.7.2.Final-offline.zip"
  version "3.7.2.Final"
  sha256 "8299f6a826cac951d90bcfd7d852698a30935f9c7475e15f90c2a632847d1350"

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
