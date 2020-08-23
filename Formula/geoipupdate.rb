class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.3.0.tar.gz"
  sha256 "0c6df6a563203e87e80c9998975c287cd4e3a5eb6c83b90dd5a0597298b098f0"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git"

  bottle do
    sha256 "8e03cdb8795a6a0dbd1a35a12c50e2021fee969926f6498369b0b04ea097c942" => :catalina
    sha256 "710a53cf245d180e66f8b4626ff22cb2587912a8e8cd17b9cb34b6d5ffcc3174" => :mojave
    sha256 "99a8bc8e63c1c8949e52fdd0fe04a27e1c2d973f2d2e9959fda52795bb7d01ed" => :high_sierra
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
