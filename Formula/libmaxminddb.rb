class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.6.0/libmaxminddb-1.6.0.tar.gz"
  sha256 "7620ac187c591ce21bcd7bf352376a3c56a933e684558a1f6bef4bd4f3f98267"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0f24eaaac537909029ab56d81f06128bc2d13a173eb3359165616f177896c556"
    sha256 cellar: :any, big_sur:       "146bfd6bdac15f837ed72873d2d76197ad948b206807482b542d4333faaed3d5"
    sha256 cellar: :any, catalina:      "8d6aa3daaa1bca81c09d9f5157abf3f32aa2e3a6f981d7f8d80ef7ac25a710e9"
    sha256 cellar: :any, mojave:        "ae37e07dae2bef7fed4e48396ac1f060a9985d3b5dad66a68175d5e3ed2991f9"
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
