class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.5.0.tar.gz"
  sha256 "dfa3ecebebe23923735612fc442388c5d8e02991b316012ab7d2738b3a48e9d4"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git"

  bottle do
    sha256 "50a8fe494f4e3f6d961323200ef496f0efa5bffa4624a18a518b46ffe3a7f3e7" => :catalina
    sha256 "dec6091fbc16a87bfdd752b95ba4ddc3d864e6c1c4255d1f7ead79d8f2656443" => :mojave
    sha256 "c1f12ee079226b233cc137d7024c1c84ceea92b13e1b2a154a7de2b859fec42b" => :high_sierra
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
