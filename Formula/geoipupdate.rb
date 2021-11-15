class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.8.0.tar.gz"
  sha256 "ca718c3ffcc595ef441363699888d20150f1d3a6583ac2d60bcbd34f052db09f"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git"

  bottle do
    sha256 arm64_monterey: "3fd3f5ed2425347901d41d310a94a177fe8fcfccb9cd8755bcb8c7ec8a5756a3"
    sha256 arm64_big_sur:  "7f8823d01da79c6839c4621a1ae80c20541fb83f6f1197278f4665b4ab4cb0ad"
    sha256 monterey:       "b25b652195cb842c9e8d93f8f58ff87e422c329b926e9dc00297c7458f66b3b6"
    sha256 big_sur:        "100e9ece8f4563fc6ed597be8cbb39c4fd4299067917234d72354df56f9a34bc"
    sha256 catalina:       "ebffdddea99838681cdb84804386668ec9f8b2ed74895ad65bae09820a8da2df"
    sha256 mojave:         "7842336aef38b28f567dd3b9d9379764f5725837eda91242aa26cfab8b2521c9"
    sha256 x86_64_linux:   "87b67e239bfa889f4a35890b50003241d4e68ad639bdd9e61274c871dea4ad6c"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "make", "CONFFILE=#{etc}/GeoIP.conf", "DATADIR=#{var}/GeoIP", "VERSION=#{version} (homebrew)"

    bin.install  "build/geoipupdate"
    etc.install  "build/GeoIP.conf"
    man1.install "build/geoipupdate.1"
    man5.install "build/GeoIP.conf.5"
  end

  def post_install
    (var/"GeoIP").mkpath
  end

  test do
    system "#{bin}/geoipupdate", "-V"
  end
end
