class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/archive/v4.6.0.tar.gz"
  sha256 "e64c3cb6f2c999e11e8401814305cbd7676c9d78a0131e06ed9dd950606dffcd"
  license "Apache-2.0"
  head "https://github.com/maxmind/geoipupdate.git"

  bottle do
    sha256 "6a0f2f009d4fc1a5c6411b35744b96320ace0d4b48757a180333c5ce433cc14c" => :big_sur
    sha256 "f087a38875f9f4b148d47b6b67d6959defb5d8793dc1066d9f8c0d3d70a3733e" => :catalina
    sha256 "de01c4e97786dcd289ebf526cbf113d7ebc5e947e8297fb21df5c4fa44bd378d" => :mojave
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
