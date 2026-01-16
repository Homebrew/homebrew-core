class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/refs/tags/v7.1.1.tar.gz"
  sha256 "f21b26d9be7281a0c90f9009ed150acb97e68e02be8a3e975315a7956de6965a"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git", branch: "main"

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "210cbe3b702c115c0aa1aab4a33e45c7b7fc1e4c08007affa29d8de72ff711e3"
    sha256                               arm64_sequoia: "78d7f7498bb083170faefe612992b4f5e2032ec9a45be6575f9be4e48a75b4dc"
    sha256                               arm64_sonoma:  "7557755567a801e49fadaebea3d4af2d44f8ed51cf6dca8e01ae9f9234a0cb35"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1ad0b7b8205a1769a41701bb81937f63b50da6aacb7a7347473dc9b5cbc466b"
    sha256                               arm64_linux:   "31ad80bc48bc56966de8174803ad404156bacc0c2d3ce8c68ff1e6db89e576a9"
    sha256                               x86_64_linux:  "6adfb1d2c719053d5d9be82450b2253d3f97ca563f850ec4ae8d280d4aedf095"
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
    (var/"GeoIP").mkpath
  end

  test do
    system bin/"geoipupdate", "-V"
  end
end
