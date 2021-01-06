class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.5.0/libmaxminddb-1.5.0.tar.gz"
  sha256 "7c56e791ff2a655215e7ed3864b1ffdd7d34a38835779efed56a42f056bd58aa"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "5ba5e0260d3c3116330850358b7619f9c216ada217a75007939a46b17b9bf487" => :big_sur
    sha256 "2c517bf0d9e0f73b3af0fee508e4419bc9aba7ddfb33af744ea4cec9d0b0c239" => :arm64_big_sur
    sha256 "a9d031d21d9ed59bad9acd3c78c8831ba15893b4939dc94652fd5834e3078cd8" => :catalina
    sha256 "0144263e2fd98cf957c38aa330b52298787f03af684b3b41efe1a0669b831bff" => :mojave
    sha256 "274e81dd90f2d35de472b21c93b1f87aaab44121c0625b116ccf859ca13cf647" => :high_sierra
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
