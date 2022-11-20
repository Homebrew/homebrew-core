class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.10.0.tar.gz"
  sha256 "12e0083eb56eb39f4304fc21ef07af566702a0d5b843f3a19d3e5e5e33099230"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git", branch: "main"

  bottle do
    sha256 arm64_monterey: "fa1c58550c7a922498c844a0ab9b94edcc3dfd790b9ea4c02380ef11d47f5a5a"
    sha256 arm64_big_sur:  "ef5c0597ef2faf8809975df62ba4438e15768683f043e6296e59a50ac858782d"
    sha256 ventura:        "2fa6ad7de9355328a1a90fe149f74254f7bc5dd1a0d7768f36ea69a31f623cdc"
    sha256 monterey:       "2f38b64724d094657593800a7973e7fbf39b230835865d2108cfe63d0a103fa6"
    sha256 big_sur:        "d0d3b637cba55a86581b099329cbbd3254bddd59306b58e32bce2b787c081dfe"
    sha256 catalina:       "cfeed208e46eb157a2c97ebbb71d9505e47da872ccfa67eae5ae2c594b037b0d"
    sha256 x86_64_linux:   "e15f1b36f5a8348e414bd94fde2bf39095b1b60b0eae81f69ffb30c36d7cc316"
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
