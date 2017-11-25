class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.3.1/libmaxminddb-1.3.1.tar.gz"
  sha256 "5d55a1327dcca5c819a6a7a260afc0d1bd9626824e40073c7564fdb8d91ca186"

  bottle do
    cellar :any
    sha256 "7a406e29c797a8a8b347d63cca25646005fd0cf8a6c7390a0da669ac3da03cac" => :high_sierra
    sha256 "f41395aa33d5179f6fbcf81df754e1058aac043eb871fd1dcadc5049d7007480" => :sierra
    sha256 "97ca7f823bb81291ef663fb462700dd46a505012a5aaaf6ce8d0861ca33f37ac" => :el_capitan
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
