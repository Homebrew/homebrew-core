class Memcacheq < Formula
  desc "Queue service for memcache"
  homepage "http://memcachedb.org/memcacheq"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/memcacheq/memcacheq-0.2.0.tar.gz"
  sha256 "b314c46e1fb80d33d185742afe3b9a4fadee5575155cb1a63292ac2f28393046"
  revision 2

  bottle do
    cellar :any
    sha256 "03bae23a3da1e51b48e9f8f0434f2e994a1fcf094150de46f713f0a4eb4e3dd5" => :sierra
    sha256 "5e8953e258ee7caa27421132d06b325b59213d5e59d22dc2ce6e90b68c6081da" => :el_capitan
    sha256 "ffc74eb29a247e07463a183c768c50c4b2d1fb8a3d2e420d2fff8d0ef6e469b1" => :yosemite
  end

  depends_on "berkeley-db"
  depends_on "libevent"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-threads"
    system "make", "install"
  end
end
