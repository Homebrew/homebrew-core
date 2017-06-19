class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/1.7/src/haproxy-1.7.6.tar.gz"
  sha256 "88f84beba34d08a5495d908ca76866e033e6046e7c74f9477b9d5316f8c3d32a"

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
