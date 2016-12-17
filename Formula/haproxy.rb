class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "http://www.haproxy.org/"
  url "http://www.haproxy.org/download/1.7/src/haproxy-1.7.1.tar.gz"
  sha256 "56a7f5e919755d9b01b64f91b497c2c4eabdbe3a6fd84f7e5192a264097d8759"

  bottle do
    cellar :any
    sha256 "809f3303bb3b129dc554c9d92290f85e78c96ccd6c252cbfc39991ae0109c790" => :sierra
    sha256 "58de3011f0ec059e8ae966ad7f6c77a2100b1eb0374c878a6a077c01d4fd2993" => :el_capitan
    sha256 "9f74786c431a5907575384c499db60a3fae8d4e1ec56aea6fb147efab65b4ebb" => :yosemite
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
