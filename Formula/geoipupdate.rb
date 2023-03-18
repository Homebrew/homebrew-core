class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.11.1.tar.gz"
  sha256 "274092583301b3ee7d750e6f738d45d95b52a5ea60806106e9aa0b7c8e242dc5"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "b351feb570a4042747823fac07c409b30c4c9bfe8d71accd7ae1f9026a002ac9"
    sha256 arm64_monterey: "7aa27165d991039c13d10d64332ede6fd9da1731a0f9c1b02f5391e91e5fe935"
    sha256 arm64_big_sur:  "32148c92b9a8e2f3c0cbcbe8313b88c831479ddf041dc8a4d4d553a2a95ab1ac"
    sha256 ventura:        "40825d9b7c7246c6ee0afaad0d14b03b7bd008e36715d0fc56e849355f6d8e10"
    sha256 monterey:       "a0c44edf69f7526c307a6e92e524965f19bd50bdd3e40c9535dc368b1d9a5d7d"
    sha256 big_sur:        "9c1269506a04416b6ef2b772b0cce759eba4322643cede561e45f531e6f7c7e0"
    sha256 x86_64_linux:   "4c93e5f089a4752a51ecda358e04f506a9f2c0bf49cddd2bd937a954db19aacd"
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
