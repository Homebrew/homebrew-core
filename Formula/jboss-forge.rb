class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "https://forge.jboss.org/"
  url "https://downloads.jboss.org/forge/releases/3.3.2.Final/forge-distribution-3.3.2.Final-offline.zip"
  version "3.3.2.Final"
  sha256 "949da58c42e66e7bf2822d019bbf7cce9051a8974f83907f2d42d598aa6b9502"

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
