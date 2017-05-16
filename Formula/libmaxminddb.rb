class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.2.1/libmaxminddb-1.2.1.tar.gz"
  sha256 "9fa2b3341c9c88117f58454dfb2dd104915a337d93c8a9a735931a63b37f7bfa"

  bottle do
    cellar :any
    sha256 "52b950c883f86dcd46b182476408c62411a014316d3a03cf0a1224c93f7b5b3a" => :sierra
    sha256 "96aa411d1eaca8f3632ea17e47a5c9f419a3ae88ba41904cd0b80b8f379ed147" => :el_capitan
    sha256 "40c0955cb584dd13feb0f6c666669d86dec523137b7fddcf1687695b902a3b95" => :yosemite
  end

  head do
    url "https://github.com/maxmind/libmaxminddb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "geoipupdate" => :optional

  def install
    system "./bootstrap" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
    (share/"examples").install buildpath/"t/maxmind-db/test-data/GeoIP2-City-Test.mmdb"
  end

  test do
    system "#{bin}/mmdblookup", "-f", "#{share}/examples/GeoIP2-City-Test.mmdb",
                                "-i", "175.16.199.0"
  end
end
