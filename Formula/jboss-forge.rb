class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "https://forge.jboss.org/"
  url "https://downloads.jboss.org/forge/releases/3.9.8.Final/forge-distribution-3.9.8.Final-offline.zip"
  sha256 "a08387f2d7010ac34e13593707d4d93a135a6e3b42cbe78ebcdae4ef3e5c0bf2"

  # The first-party download page (https://forge.jboss.org/download) uses
  # JavaScript to render the download links and the version information comes
  # from the /api/metadata endpoint in JSON format.
  livecheck do
    url "https://forge.jboss.org/api/metadata"
    regex(/["']latestVersion["']:\s*["']([^"']+?)["']/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "d7570b0c75b054635f6718eb8eab0702fcde155bb94f460c85d4c667adda953c"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install %w[addons bin lib logging.properties]
    bin.install libexec/"bin/forge"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "org.jboss.forge.addon:core", shell_output("#{bin}/forge --list")
  end
end
