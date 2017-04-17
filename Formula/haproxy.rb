class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/1.7/src/haproxy-1.7.4.tar.gz"
  sha256 "dc1e7621fd41a1c3ca5621975ca5ed4191469a144108f6c47d630ca8da835dbe"

  bottle do
    cellar :any
    sha256 "fdd36fc4946c6b45cb72f2e4fb98659e274606ea07fb76edcbec051fe6de6de8" => :sierra
    sha256 "edb7e8caecf0d7539d730eca8c939697d07bb1a235b18dc1c016e86e7bd40c80" => :el_capitan
    sha256 "07eb7eaf898e5855614d8da183a9fca3250cae0cbb3b7eeec957a6cac94aed60" => :yosemite
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
