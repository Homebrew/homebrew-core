class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "http://www.haproxy.org/"
  url "http://www.haproxy.org/download/1.7/src/haproxy-1.7.0.tar.gz"
  sha256 "abdce486f98c024f3df45dade4011caeb925f48129370f4754a45f1623794622"

  bottle do
    cellar :any
    sha256 "f42e94e112c04939fb9b36438a8d99faf00fac21b8fa06c753557771224c713d" => :sierra
    sha256 "787cffd629efcf06bdea6749da2202b8c9f19b163fc396734ca8111e6c5524fb" => :el_capitan
    sha256 "5b4e648b9b548df3e6735b28ae96281e41511857b20b7eff134ca90b0b270aca" => :yosemite
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
