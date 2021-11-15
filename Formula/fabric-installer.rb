class FabricInstaller < Formula
  desc "Installer for Fabric for the vanilla launcher"
  homepage "https://fabricmc.net/"
  url "https://maven.fabricmc.net/net/fabricmc/fabric-installer/0.9.0/fabric-installer-0.9.0.jar"
  sha256 "11bf2058eb2d0441e1af38f570c5b920571449dadb2e316fcf021ba78443592b"
  license "Apache-2.0"

  # The first-party download page (https://fabricmc.net/use/) uses JavaScript
  # to create download links, so we check the related JSON data for versions.
  livecheck do
    url "https://meta.fabricmc.net/v2/versions/installer"
    regex(/["']url["']:\s*["'][^"']*?fabric-installer[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b7fa19341a08ead6b8188ecf0cf61e4f6eca400c416ddb94b6f65de17b17a82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b7fa19341a08ead6b8188ecf0cf61e4f6eca400c416ddb94b6f65de17b17a82"
    sha256 cellar: :any_skip_relocation, monterey:       "4b7fa19341a08ead6b8188ecf0cf61e4f6eca400c416ddb94b6f65de17b17a82"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b7fa19341a08ead6b8188ecf0cf61e4f6eca400c416ddb94b6f65de17b17a82"
    sha256 cellar: :any_skip_relocation, catalina:       "4b7fa19341a08ead6b8188ecf0cf61e4f6eca400c416ddb94b6f65de17b17a82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b7fa19341a08ead6b8188ecf0cf61e4f6eca400c416ddb94b6f65de17b17a82"
  end

  depends_on "openjdk"

  def install
    libexec.install "fabric-installer-#{version}.jar"
    bin.write_jar_script libexec/"fabric-installer-#{version}.jar", "fabric-installer"
  end

  test do
    system "#{bin}/fabric-installer", "server"
    assert_predicate testpath/"fabric-server-launch.jar", :exist?
  end
end
