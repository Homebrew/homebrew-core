class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.1.5.tar.gz"
  sha256 "fba0de08136af05038c2375e24f0eb2cfddf46caa2ec946dc1417d72d1108fed"
  head "https://github.com/maxmind/geoipupdate.git"

  bottle do
    rebuild 1
    sha256 "a7fcce24fbb621ebf66a1795ad4686aee730cfe3bce6406b7f2a94be7a48e64e" => :catalina
    sha256 "26c697322efb8b8338eb2e8bf7cf6ac614c83ce5762b19282efc1657ed111924" => :mojave
    sha256 "f1f845e316c11b9c62d83f4c251d9a16fa5e831a137c6328b071dff9b6de5359" => :high_sierra
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
    system bin/"geoipupdate", "-v"
  end

  test do
    system "#{bin}/geoipupdate", "-V"
  end
end
