class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.2.2.tar.gz"
  sha256 "a9267a1fbbadc4686198002d3de0ef60a65e3b47c4e050bcdccf692aa1791092"
  head "https://github.com/maxmind/geoipupdate.git"

  bottle do
    sha256 "e860b51cd8d075ab3a96827795d8e210c2b7ac88f6502ccdb4ad9533e2e189f2" => :catalina
    sha256 "84b1047359a60c208d00fab6f78ed5942236117b4680f7381e0a5f78cc9a911e" => :mojave
    sha256 "92441c75c201f0b29c0b57e78e5a3025b19ef1f7e6f871f0238d65b77fe44174" => :high_sierra
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
