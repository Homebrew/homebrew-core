class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.2.1/libmaxminddb-1.2.1.tar.gz"
  sha256 "9fa2b3341c9c88117f58454dfb2dd104915a337d93c8a9a735931a63b37f7bfa"

  bottle do
    cellar :any
    sha256 "f588eba7a6f844571e474ed5369b5b4fde1d6f9a0a3f5ce8674e42861f0126da" => :sierra
    sha256 "626d41d5b47374ce9bdd046e1b958ab68536efd772ebd0ad0949e453589ced39" => :el_capitan
    sha256 "345c405bbdcfa1fad247e838f594b522b935e41ddbf7b7760e7404121a3475f3" => :yosemite
    sha256 "9046beb8d9abb5002e367594b39ca4fd5e121ca9977cc37e07437c5b8a684a80" => :mavericks
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
