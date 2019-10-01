class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.3.2/libmaxminddb-1.3.2.tar.gz"
  sha256 "e6f881aa6bd8cfa154a44d965450620df1f714c6dc9dd9971ad98f6e04f6c0f0"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7c28cec294ec7108b63159fcf8c2a994821e4e3f0480d81101eef919a499d72f" => :catalina
    sha256 "acf88e8898d4fe9f8edb9ec139bc69c7837d4559841e23c2c605461b4c64fa23" => :mojave
    sha256 "a36f2a9faa9fcea3fabb861023787991ac047691c4016fdcdab320ff172f0f61" => :high_sierra
    sha256 "8a93a000841cffd2f64d33f26a0777eb860ae0bac887bb72b539047acc61e3c0" => :sierra
  end

  head do
    url "https://github.com/maxmind/libmaxminddb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

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
