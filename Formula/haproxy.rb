class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/1.7/src/haproxy-1.7.6.tar.gz"
  sha256 "88f84beba34d08a5495d908ca76866e033e6046e7c74f9477b9d5316f8c3d32a"

  bottle do
    cellar :any
    sha256 "390329d73d906d1662d062c85d5155e7bb913c36b5194962d8cf04762fd42d92" => :sierra
    sha256 "f0b9c736a73e225a0faf00604f65f42b86119faed260da5811e861dcd91062dd" => :el_capitan
    sha256 "942911b7a0c2c056024467fcaa60b893115e63156ee438822851afb34f0c6949" => :yosemite
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
