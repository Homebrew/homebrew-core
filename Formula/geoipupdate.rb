class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.0.6.tar.gz"
  sha256 "ce6801ca40a1f57376d1f899a8542365d472511e397562b9fe00fa5f4f4fbe4e"
  head "https://github.com/maxmind/geoipupdate.git"

  bottle do
    sha256 "dc135710f5fbb7d6ae9bc623623e3d11a4e62a7b9329148d67a2fcaa1ab9d737" => :catalina
    sha256 "508412ba6097dc729084f988db31d39c758ec871ccc4226a9e2f54a7a4c3f823" => :mojave
    sha256 "9f824749df004fc0838df8959ec22583e7cbc81c7a220b986f515c491189ba29" => :high_sierra
    sha256 "ca7fc732a639645d3b737b1a3bbb47e91e24cd1cf1606ed9b3e218b33bcd45a5" => :sierra
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/maxmind/geoipupdate").install buildpath.children

    cd "src/github.com/maxmind/geoipupdate" do
      system "make", "CONFFILE=#{etc}/GeoIP.conf", "DATADIR=#{var}/GeoIP", "VERSION=#{version} (homebrew)"

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
