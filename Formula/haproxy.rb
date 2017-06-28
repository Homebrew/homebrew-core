class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/1.7/src/haproxy-1.7.7.tar.gz"
  sha256 "81196ca449e4ada45fbd743fe3804bb82c25563ff9653e136872181ee5603ae2"

  bottle do
    cellar :any
    sha256 "55e5a0cd360d82f2b18fe8bcf18ffc188ddb498d41b3d5b8aab9d683c153cadb" => :sierra
    sha256 "4f2c514a6b857249169adef6bfdd1359f857949ecee93ae54b77cb659c2353f7" => :el_capitan
    sha256 "7058ff4d8265c59c2073fd15a02fb577e4ae0c801d67569c6c7b45bfb5725e03" => :yosemite
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
