class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "http://www.haproxy.org/"
  url "http://www.haproxy.org/download/1.6/src/haproxy-1.6.5.tar.gz"
  sha256 "c4b3fb938874abbbbd52782087117cc2590263af78fdce86d64e4a11acfe85de"

  bottle do
    cellar :any
    sha256 "0ce21c479a65bc9679beccb1c12c6169456c7423992361349592fbbdfece46cf" => :el_capitan
    sha256 "30c7bbe13b4aee9ff08b9c0b1018256fba6c7128d37cf575898e937a84bd0d30" => :yosemite
    sha256 "7453628010e06eb07167b89bed4ae02d174cb22fa83de4d76cdc3318ed40da83" => :mavericks
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
