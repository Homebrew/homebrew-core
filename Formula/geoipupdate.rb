class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/releases/download/v3.0.0/geoipupdate-3.0.0.tar.gz"
  sha256 "0caa618b5b541fe6ef12a29362f0a19138ce6ab89b7581aaa9b21a2605534dac"

  bottle do
    sha256 "a3003ca29d2493ea0c12bc36858d0e7a7ab3c7c98d617c885e35e93e08e0a55b" => :high_sierra
    sha256 "ca8143cde1b5ec7772c50fbbfb424f4e9bf5ea828cb68955434036d708eb9c6e" => :sierra
    sha256 "0a09000bf9f1e502eae25793603b9b374ef3756e5bda1cbeb36958d1aa6cbef1" => :el_capitan
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
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  def post_install
    (var/"GeoIP").mkpath
    system bin/"geoipupdate", "-v"
  end

  test do
    system "#{bin}/geoipupdate", "-V"
  end
end
