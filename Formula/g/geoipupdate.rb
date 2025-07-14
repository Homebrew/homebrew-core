class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/refs/tags/v7.1.1.tar.gz"
  sha256 "f21b26d9be7281a0c90f9009ed150acb97e68e02be8a3e975315a7956de6965a"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git", branch: "main"

  bottle do
    sha256 arm64_sequoia: "a1fce4eecb43e422c6059f26c6c9d2bb9719da01c204e575c3abd5fb840a3ebf"
    sha256 arm64_sonoma:  "17e2d973de456a8d6dd3f0c605a7980d87b3b4e0388345fa2f6420286cf40ac1"
    sha256 arm64_ventura: "500173a96598a74be77f30c05428abdee5961e15230f2d0a6970ee12fcc0fbed"
    sha256 sonoma:        "1b64e26cb80d3234c7c5457a439f0ca92a5768e67e12651bd0156d70a76d3c52"
    sha256 ventura:       "e19a2bedba79459c9f65316bac05d8947073862c05398e950f49b3e4cbfcaf94"
    sha256 x86_64_linux:  "e36b9d057548f0750a86f44d0a4940819506f0972e417677d830d62cb5970781"
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
