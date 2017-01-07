class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/releases/download/v2.3.1/geoipupdate-2.3.1.tar.gz"
  sha256 "4f71e911774c4fd32e217889c242d2c311fa5ffd3df56be48a2d1aedfe2e671c"

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

  option :universal

  def install
    ENV.universal_binary if build.universal?

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
