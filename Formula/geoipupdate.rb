class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.11.1.tar.gz"
  sha256 "274092583301b3ee7d750e6f738d45d95b52a5ea60806106e9aa0b7c8e242dc5"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "17450940e17bf4b545815fb61fbd777f02d026dc1a1d6253ad22f7f581cecb3d"
    sha256 arm64_monterey: "a50870246ed218c50c3a77c7d9efe40f6b23c541c15d0056ef71ed4f45c19b96"
    sha256 arm64_big_sur:  "19cee05c7f9432d18aece98484d10129898fc98b799f56c9969ed11568d17f23"
    sha256 ventura:        "a7ad1a9d9e73a5b82ccf4c2c7df9372e3a3e776e44f190f6b6e3063d5b69fdc4"
    sha256 monterey:       "4c5cbe614c186ba599b19395684e4287c1e4a8d1f17bb1ceb03c8722001da8a7"
    sha256 big_sur:        "81cd0c73f9e76ef46450c8132d5d00a4d33c672424375cc1433d2964886b97ed"
    sha256 x86_64_linux:   "241065938b037aeafbd3d3817c9a715057ca12ff52e8f688e4fe98e8963f3345"
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
