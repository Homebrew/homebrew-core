class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.0.6.tar.gz"
  sha256 "ce6801ca40a1f57376d1f899a8542365d472511e397562b9fe00fa5f4f4fbe4e"
  head "https://github.com/maxmind/geoipupdate.git"

  bottle do
    sha256 "5c96cc7a1cbcfeb9e717b3072796a24054891ef05c9f73e987ff6e2d7a3375dc" => :mojave
    sha256 "98a7b033d8c21618a767d5d138addcb033e01cd3aeafd4607197d89e971274cc" => :high_sierra
    sha256 "f692fb91552ecef316cab9713e63155b5053628f3a9d4d791d439ba62d23978f" => :sierra
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
