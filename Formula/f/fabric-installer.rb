class FabricInstaller < Formula
  desc "Installer for Fabric for the vanilla launcher"
  homepage "https://fabricmc.net/"
  url "https://maven.fabricmc.net/net/fabricmc/fabric-installer/1.0.0/fabric-installer-1.0.0.jar"
  sha256 "7d7e5b1d3a7f8e2081069898e95dc71d84bb3a5c79cb235c034895173cfd347b"
  license "Apache-2.0"

  # The first-party download page (https://fabricmc.net/use/) uses JavaScript
  # to create download links, so we check the related JSON data for versions.
  livecheck do
    url "https://meta.fabricmc.net/v2/versions/installer"
    regex(/["']url["']:\s*["'][^"']*?fabric-installer[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c91c4421286fb38135856bb113e78a43ee44f80454efb8891c5bdf17e946ddcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4126ef7546f0feaadfbd1238b808319f76e70791b8ddc2341a673cb6cb0598be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4126ef7546f0feaadfbd1238b808319f76e70791b8ddc2341a673cb6cb0598be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4126ef7546f0feaadfbd1238b808319f76e70791b8ddc2341a673cb6cb0598be"
    sha256 cellar: :any_skip_relocation, sonoma:         "c91c4421286fb38135856bb113e78a43ee44f80454efb8891c5bdf17e946ddcf"
    sha256 cellar: :any_skip_relocation, ventura:        "4126ef7546f0feaadfbd1238b808319f76e70791b8ddc2341a673cb6cb0598be"
    sha256 cellar: :any_skip_relocation, monterey:       "4126ef7546f0feaadfbd1238b808319f76e70791b8ddc2341a673cb6cb0598be"
    sha256 cellar: :any_skip_relocation, big_sur:        "4126ef7546f0feaadfbd1238b808319f76e70791b8ddc2341a673cb6cb0598be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99531a98bd6324b373148e0e35a1d4f995ebfd49af888a779fd005b18f652d75"
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
