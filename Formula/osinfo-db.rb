class OsinfoDb < Formula
  desc "Osinfo database of operating systems for virtualization provisioning tools"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/osinfo-db-20210531.tar.xz"
  sha256 "e46d769692e5bd985abe2e376209adafec33db77f10b35999c71b7a140963ec0"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/libosinfo/?C=M&O=D"
    regex(/href=.*?osinfo-db[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2959d7b71fe06406c67784c91f23d9af81ce4418a6a1e07c0c6731dc7550c8d8"
  end

  depends_on "osinfo-db-tools" => [:build, :test]

  def install
    system "osinfo-db-import", "--dir=#{share}/osinfo", cached_download
  end

  test do
    system "osinfo-db-validate", "--system"
  end
end
