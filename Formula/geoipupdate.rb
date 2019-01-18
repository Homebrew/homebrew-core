class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.0.2.tar.gz"
  sha256 "76a2bd8e75fbe1d88cfdf0ab7f00e90cfea7c87b8757d6f5147a3d4d2d9773b3"
  head "https://github.com/maxmind/geoipupdate.git"

  bottle do
    sha256 "436a7ab7419e729dd34baef9911a4678ebe64476f8685db749e1e37604309101" => :mojave
    sha256 "97e79bf640aeceee8e0fc39f3307049fbb394ba8585c9f651d3057c3acf88b37" => :high_sierra
    sha256 "ac19d7498d7b2fe1c6a1c0e9c8d401813b3b3b38effbfd34b58b26cd6bef989c" => :sierra
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
