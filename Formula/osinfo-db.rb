class OsinfoDb < Formula
  desc "Osinfo database of operating systems for virtualization provisioning tools"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/osinfo-db-20210903.tar.xz"
  sha256 "30e7d3f21bc0d3a24fd23da29f6364afe896d7c9e2dfb39f0999ffc6b7730834"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/libosinfo/?C=M&O=D"
    regex(/href=.*?osinfo-db[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a7317e117b25335079ea40f9917680e2123a10e4a15738312bd561a8af7c7e0f"
  end

  depends_on "osinfo-db-tools" => [:build, :test]

  def install
    system "osinfo-db-import", "--dir=#{share}/osinfo", cached_download
  end

  test do
    system "osinfo-db-validate", "--system"
  end
end
