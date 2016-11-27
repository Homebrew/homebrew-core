class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "http://www.haproxy.org/"
  url "http://www.haproxy.org/download/1.7/src/haproxy-1.7.0.tar.gz"
  sha256 "abdce486f98c024f3df45dade4011caeb925f48129370f4754a45f1623794622"

  bottle do
    cellar :any
    sha256 "13c61ca163077482f6b6e5b16c3281352f31231a614f39ae20d85437edae89fa" => :sierra
    sha256 "30d66635eb7d1fea4ad6759b09802ce50b62c6cf987d7a4768ecc3655ab32810" => :el_capitan
    sha256 "60cb57861b8cc41983be62e50aa6da544fe1b8aa2c2b7f7c8e1d2e28f99c2134" => :yosemite
    sha256 "9f4007f4f12ac804273d8dd7eadcf6214f0a312e0145ec6fa26ccbab9ae32ec7" => :mavericks
  end

  depends_on "openssl"
  depends_on "pcre"

  def install
    args = %w[
      TARGET=generic
      USE_KQUEUE=1
      USE_POLL=1
      USE_PCRE=1
      USE_OPENSSL=1
      USE_ZLIB=1
      ADDLIB=-lcrypto
    ]

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", *args
    man1.install "doc/haproxy.1"
    bin.install "haproxy"
  end

  test do
    system bin/"haproxy", "-v"
  end
end
