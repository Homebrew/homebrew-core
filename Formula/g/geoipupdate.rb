class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/refs/tags/v7.1.1.tar.gz"
  sha256 "f21b26d9be7281a0c90f9009ed150acb97e68e02be8a3e975315a7956de6965a"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git", branch: "main"

  bottle do
    rebuild 2
    sha256                               arm64_tahoe:   "6ffcdd5b4d20042abc7c43cfad948193d2dcc608bbcf3a0e8df942b05c0995ad"
    sha256                               arm64_sequoia: "6edf968afba83f6d986ca2dc7ee31b3b2538f2307788fa0f51febbafc66ce702"
    sha256                               arm64_sonoma:  "12a26bb493069864f06579428ef9a2ba1278883bc6209fa9e97cca49fb814c62"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c1a3de1f94838ecf0836a3966342dcafa2101f3c44908823e88493ae3262574"
    sha256                               arm64_linux:   "800bb13a38ccb17e75e9dc3c724f7e859a2bf5ba4c32e9fb55947e42c183a675"
    sha256                               x86_64_linux:  "96189a674d2791bf8d4eb5063077bf00ba59c7c78d9044f17a12d4cf58afb114"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
