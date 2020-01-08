class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.4.2/libmaxminddb-1.4.2.tar.gz"
  sha256 "dd582aa971be23dee960ec33c67fb5fd38affba508e6f00ea75959dbd5aad156"

  bottle do
    cellar :any
    sha256 "737fa40053d963f1c658c1de368d467309eb716869350192fc844aff3a078c23" => :catalina
    sha256 "bf9f7295d6295f51d94e88562dca6b5d979bd0d141cd74c0cfa78941d4b74d7a" => :mojave
    sha256 "960dd0e63819fc6fb50c83085f013df073308e35df378e2ab5916f96da71389e" => :high_sierra
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
