class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.0.2.tar.gz"
  sha256 "76a2bd8e75fbe1d88cfdf0ab7f00e90cfea7c87b8757d6f5147a3d4d2d9773b3"
  head "https://github.com/maxmind/geoipupdate.git"

  bottle do
    sha256 "9cf68c91a00193bed2bd55b3c2d8add1fa937433a429af7c01829b14a58eb7fa" => :mojave
    sha256 "1e45c489ab5d3022b71e00adca105287de4175ae999552a1f0f62981a16cbf4c" => :high_sierra
    sha256 "d13fd47dd374265af81e2824335b714bd647359671f82ed6643ae988722647fc" => :sierra
    sha256 "a8fdd107eca63868f7ae9e216f3ecab4bb1c0ce635d9bda0fdb03d35f37d1380" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/maxmind/geoipupdate").install buildpath.children

    cd "src/github.com/maxmind/geoipupdate" do
      system "make", "CONFFILE=#{etc}/GeoIP.conf", "DATADIR=#{var}/GeoIP"

      bin.install  "build/geoipupdate"
      etc.install  "build/GeoIP.conf"
      man1.install "build/geoipupdate.1"
      man5.install "build/GeoIP.conf.5"
    end
  end

  def post_install
    (var/"GeoIP").mkpath
    system bin/"geoipupdate", "-v"
  end

  test do
    system "#{bin}/geoipupdate", "-V"
  end
end
