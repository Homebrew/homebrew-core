class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v5.1.1.tar.gz"
  sha256 "ecd2d7c594ef53c8251e6670d439ea1808bc747669375b836f4457a448327b14"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "604eb4046ae04c94b01dcdebd37eb21f17ac6f556255cd4ee7f69f820a8acd9d"
    sha256 arm64_monterey: "874d8ec40ce5245853df6cc334008eaf047157c581fe8da2ee7f49baadce406c"
    sha256 arm64_big_sur:  "62e70a475e0e189ba58501c3e75ce536e45a184123e6e8c11ea1b072f14f56b7"
    sha256 ventura:        "a90a656e3d4520053be0b111c0667a146611c5ee56b189be1d4db26d1dafbce8"
    sha256 monterey:       "e141725fc91916a5d70f36afb7ab04046538b8efbb0ce5c10802d73b7713d8de"
    sha256 big_sur:        "1270ab4e4224e27537c6b942e8ac8dcd0d43b6eb2ed4abad08fa2c1b8e7c837d"
    sha256 x86_64_linux:   "d424ae54576fae4c4fd2d919a3787cebecd38438efbb38568f9e3bdf21f1bafd"
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
