class FabricInstaller < Formula
  desc "Installer for Fabric for the vanilla launcher"
  homepage "https://fabricmc.net/"
  url "https://maven.fabricmc.net/net/fabricmc/fabric-installer/0.11.1/fabric-installer-0.11.1.jar"
  sha256 "7917f9fa14be6da6ef3cdb7fe6bf3b63a593a0eb873bd627e981a7e3988cd73a"
  license "Apache-2.0"

  # The first-party download page (https://fabricmc.net/use/) uses JavaScript
  # to create download links, so we check the related JSON data for versions.
  livecheck do
    url "https://meta.fabricmc.net/v2/versions/installer"
    regex(/["']url["']:\s*["'][^"']*?fabric-installer[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9428f27d95d8ae7e4f552f3ba6a426add1c3184fa127f219b8bd19385881b61a"
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
