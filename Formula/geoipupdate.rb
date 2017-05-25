class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/releases/download/v2.4.0/geoipupdate-2.4.0.tar.gz"
  sha256 "8b4e88ce8d84e9c75bc681704d19ec5c63c54f01e945f7669f97fb0df7e13952"

  bottle do
    sha256 "4138b18781d3e1c26f0b225f6a8e1ecb53882584fbab3c01cab05b387d3fefb9" => :sierra
    sha256 "526cddf88ba06b7a90702ad4b6602e9f63b7646e0904e244d86bf8992c908fb8" => :el_capitan
    sha256 "6f1396a383de18597334f0b10486d0c447ac1426fbf640804603b3c82745d250" => :yosemite
  end

  head do
    url "https://github.com/maxmind/geoipupdate.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./bootstrap" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--datadir=#{var}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    (var/"GeoIP").mkpath
  end

  test do
    system "#{bin}/geoipupdate", "-V"
  end
end
