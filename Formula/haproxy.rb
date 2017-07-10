class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/1.7/src/haproxy-1.7.8.tar.gz"
  sha256 "ec90153ccedd20ad4015d3eaf76b502ff1f61b431d54c22b8457b5784a9ae142"

  bottle do
    cellar :any
    sha256 "05a01acfc348351a468fb7b622cf606f86e38a87a17e3309f93a8588f732cfed" => :sierra
    sha256 "70037018ffd616f652a1705fe3afd454e63b04d61152504255e47d87db3a57a8" => :el_capitan
    sha256 "a686d6450890269dc1c196653668e6a27afe70527e6b6a69631f3fd9ec119fcc" => :yosemite
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
