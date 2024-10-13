class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/refs/tags/v7.0.1.tar.gz"
  sha256 "59c80ab737f128fc05e4ecdec4d84652182851dc8c8bea892022e3fc12db9101"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git", branch: "main"

  bottle do
    sha256 arm64_sequoia:  "8b837513d3e95ad9f14d9ae09233ceb662140b875b13c6e9afacd129fbdf890a"
    sha256 arm64_sonoma:   "ff0063a996d01a0b1072191a821f42c85ddf94cade101d39b47a24b2ab5488bb"
    sha256 arm64_ventura:  "207a09ecc2abd3cbeec899b7c070e7d4a77961d24f8d5fe723e23e454b784635"
    sha256 arm64_monterey: "936095b925f1eee1921482dd93f0e5ebcb942d215db8e962faaa3e29446a0a14"
    sha256 sonoma:         "82c628d8c011f90f08b0adeaa00c72da8b4393fba61aca2f0bc027132c54523b"
    sha256 ventura:        "c49b1ffb5af72a5b6191ea7a6352f194a1973b8fce5c0168fcd5c9cfb39477bb"
    sha256 monterey:       "dd0d88ecb489a04f098b871f3a4341443de67d088c8bab3efc74c285b3732980"
    sha256 x86_64_linux:   "b5135fa64973d1d4588e161a0fa15b5452d9f88bb06e120b741358d2ce1c71a5"
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
    system bin/"geoipupdate", "-V"
  end
end
