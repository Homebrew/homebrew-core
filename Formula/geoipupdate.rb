class Geoipupdate < Formula
  desc "Automatic updates of GeoIP2 and GeoIP Legacy databases"
  homepage "https://github.com/maxmind/geoipupdate"
  url "https://github.com/maxmind/geoipupdate/releases/download/v2.3.1/geoipupdate-2.3.1.tar.gz"
  sha256 "4f71e911774c4fd32e217889c242d2c311fa5ffd3df56be48a2d1aedfe2e671c"

  bottle do
    sha256 "6d97beeb4009a1d236d16327dc45c20d6c0db893cb2f2d9a4f2e77079555e3c0" => :sierra
    sha256 "0e69897d110e62e85a16536ee88955bd99ec20e428436f02253b8017535f5c48" => :el_capitan
    sha256 "3cb6006adb116784d3aec5415be409feb2d663595fa05defab110d5856029b8b" => :yosemite
    sha256 "5738a8729ef6111da261f11d7819d614d3d22c48d0261caea89b12b668b62a7e" => :mavericks
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
