class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.9.1/libmaxminddb-1.9.1.tar.gz"
  sha256 "a80682a89d915fdf60b35d316232fb04ebf36fff27fda9bd39fe8a38d3cd3f12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a68c2e3ca963ae2c2be7096905185cd6af3c8be66fd6deb97b6bd6897005846e"
    sha256 cellar: :any,                 arm64_ventura:  "5bf964040dd9d21ac34f5b5e1ff7b7677aab0171819ea3d7104fe9ed0d76cb9c"
    sha256 cellar: :any,                 arm64_monterey: "9839e29df83bfe1756f79dbbc33ed42fb35fac4770fb57b5b29851bafbff3b93"
    sha256 cellar: :any,                 sonoma:         "7e6d1878c0776ef7ebee5abd47c5a6ba818ad6b69d8e52a928a6acb9b3e73ffe"
    sha256 cellar: :any,                 ventura:        "d81a6413f69afd1273ad0edd17f0438d2c282de48f4081044476290418055340"
    sha256 cellar: :any,                 monterey:       "07f7fefb623fdb591636dd1579606c247ff0bfd63ea4c228a713c6d3413b75a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64324c33587d79e18deed69aeb0ffb4cd7c6b2503ce03aa572c3a7ed1ca8a0fc"
  end

  head do
    url "https://github.com/maxmind/libmaxminddb.git", branch: "main"

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
