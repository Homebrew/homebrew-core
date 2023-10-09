class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v6.0.0.tar.gz"
  sha256 "50a403fb8f94029824766b32d4bf46e67c051699f761df8c4e2c916ecca4126e"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git", branch: "main"

  bottle do
    sha256 arm64_sonoma:   "49f24731d597989bdb83dba886556eddb60e14735737854effbf84cc95a5e64c"
    sha256 arm64_ventura:  "b30fe66fde524cb2ffbe297d3d1eef0750be0f3e2cb1ff5170a45fd879713bb5"
    sha256 arm64_monterey: "3b0b019f29653493e6f7bc652a2e16a2b0c43d56bd62fc2776b6af0cb78c7475"
    sha256 arm64_big_sur:  "4dd7d15920d63dd89f7087a46ec7f863b0e0e0a6647ea86eb1f854af224f23bb"
    sha256 sonoma:         "28fa370720ca238a449579f78d49b76bdc419e9265b98b2201ed33d1ca5537f5"
    sha256 ventura:        "555b5e598c98ffa42baf90f229dacfbce06b425bd14334be65e0b07d6bec0bf3"
    sha256 monterey:       "eb9e5d40ad470e73e6003b50fd1a2c73f8c7efe45eb7c8bad575e44673a65050"
    sha256 big_sur:        "e0d638b9b272f8a00e10c9e8e0ac87368916dbdcc3b2a7eb6a35bcae4a435f0f"
    sha256 x86_64_linux:   "1b26a395ef487e7c9e6072c0038291121d8a125a1471a815b9015fe213de5026"
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
