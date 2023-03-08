class OsinfoDb < Formula
  desc "Osinfo database of operating systems for virtualization provisioning tools"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/osinfo-db-20230308.tar.xz"
  sha256 "546ba04ecc5e933ba2d7f3f3b4333a2980d4ae4dfc5284989b9c54758f2b9088"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/libosinfo/?C=M&O=D"
    regex(/href=.*?osinfo-db[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "88e5f6b6249f8a2f0ceaabfb15f502c72faae22edd82bd4b506bee5b9768e177"
  end

  depends_on "osinfo-db-tools" => [:build, :test]

  def install
    system "osinfo-db-import", "--dir=#{share}/osinfo", cached_download
  end

  test do
    system "osinfo-db-validate", "--system"
  end
end
