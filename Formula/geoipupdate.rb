class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.10.0.tar.gz"
  sha256 "12e0083eb56eb39f4304fc21ef07af566702a0d5b843f3a19d3e5e5e33099230"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "304bb59cdd78e93f82fa132e9cdb52176fc3dab7c7780ba6ba76115a6c708e1a"
    sha256 arm64_big_sur:  "0ddd44ee3db354ba26d8b15031fb366366e0de4aa580c5db3ff60f0a4f83888a"
    sha256 monterey:       "01040a579d4d17c095333fc706434d542d6dfd9bec6b4e6d7e039e285a9a9f6f"
    sha256 big_sur:        "2c1a3cb140c23ec20b0736b53de2e2036d03fabcf385414a7cd79b4b301f340d"
    sha256 catalina:       "d85ec718f4bd27036a505a5bc995cc25998aa7a9d2cb6006fc74e0a8050e86b2"
    sha256 x86_64_linux:   "80150859d8042cc5d70165c637b6fe20b2c547d867f4944826a04e938faacb73"
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
