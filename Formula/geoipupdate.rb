class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.7.1.tar.gz"
  sha256 "e3176325f916571244562a2fec58e0c9ce624f84dbf946616921be8521cbfd94"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git"

  bottle do
    sha256 big_sur:  "b5c232a0ac91e47dda58b3c306a6a2ae6fa9359175b6b7fe728c58badd9ebca2"
    sha256 catalina: "5db41634e443ee202ccfd411505a9f0371f7e8f62d1874092638669cc086bf75"
    sha256 mojave:   "651914c92d4db3bc5cea5c38ab93cd7fbafa290ea70d05a523dae7ae5edf1c01"
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
