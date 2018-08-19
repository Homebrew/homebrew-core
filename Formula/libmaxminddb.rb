class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.3.2/libmaxminddb-1.3.2.tar.gz"
  sha256 "e6f881aa6bd8cfa154a44d965450620df1f714c6dc9dd9971ad98f6e04f6c0f0"

  bottle do
    cellar :any
    sha256 "2a813d1c4f52b5c927d558f80f62a4c3cbeedf8a263f67aacdfb9b325e735fbe" => :mojave
    sha256 "499fa6bcf160d61221917ce8d3ea56c37649dc0fa2e398c9ab3140dba6e19d36" => :high_sierra
    sha256 "d320f15ceac3a01d9867c1995d5c2aaf58f1fbdb690e18233df13a3c67e53e50" => :sierra
    sha256 "3bdf70b45906a529c527c9831954210bb29629cfdc989e0087e08d9ec95085f8" => :el_capitan
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
