class JbossForge < Formula
  desc "Tools to help set up and configure a project"
  homepage "https://forge.jboss.org/"
  url "https://downloads.jboss.org/forge/releases/3.10.0.Final/forge-distribution-3.10.0.Final-offline.zip"
  sha256 "0c57ea7ad90cbc5e654dd09623f385c192c6fabe366a30c11597b49bb09f7fb3"
  license "EPL-1.0"

  # The first-party download page (https://forge.jboss.org/download) uses
  # JavaScript to render the download links and the version information comes
  # from the /api/metadata endpoint in JSON format.
  livecheck do
    url "https://forge.jboss.org/api/metadata"
    regex(/["']latestVersion["']:\s*["']([^"']+?)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "039e353a849ef77ca6c9f75b6ec8de8be60b8afca474b1850d6ced23aee6d44e"
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
