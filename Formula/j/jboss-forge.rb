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
    strategy :json do |json|
      json["latestVersion"]
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "f94f4ca9e8be07c5fbcf13f5c685b071091e4ee55dbe6e0bb33cbfc378fa9d07"
  end

  depends_on "openjdk"

  conflicts_with "foundry", because: "both install `forge` binaries"

  def install
    rm(Dir["bin/*.bat"])
    libexec.install %w[addons bin lib logging.properties]
    bin.install libexec/"bin/forge"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "org.jboss.forge.addon:core", shell_output("#{bin}/forge --list")
  end
end
