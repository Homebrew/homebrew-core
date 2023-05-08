class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v5.1.0.tar.gz"
  sha256 "fcf3dd2e901a0eb3ae88d1422b9049e8c6f46740318787502b2382c4deea3bc8"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "9c02e51e88e232acea0d6e29a994171caf26a87a17a4ba301e09b151df499883"
    sha256 arm64_monterey: "cd51056b2b2a080d3f13eb231b24b34ee75f1ad0acbe5dafc3ae674206935ec9"
    sha256 arm64_big_sur:  "6f1e80383e056376455998b43b0a484619bd3a2d6c1e454b3dd68761f4a5bad1"
    sha256 ventura:        "df244ca686dae4ee761223e5bd8107149fa428a45ea5f74f9ba2b491a67c1a51"
    sha256 monterey:       "c4fc0fcb2669e10a3f89b62ed03b52afdd4cf88c9e82edb85179bf947f62f6ca"
    sha256 big_sur:        "cd65fe353a69d31af05c88d53bc8888c483d51fac8531acee13ddf5636ef6a6f"
    sha256 x86_64_linux:   "84cf445611b685c512849eac17e38184aa908567fc96c5966463cf4184a5ffd9"
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
