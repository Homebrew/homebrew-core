class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/1.7/src/haproxy-1.7.4.tar.gz"
  sha256 "dc1e7621fd41a1c3ca5621975ca5ed4191469a144108f6c47d630ca8da835dbe"

  bottle do
    cellar :any
    sha256 "501ee9342d8566edb59b18f5ca2b4a5c636ccd0539defd9d4d9f1603fe91c165" => :sierra
    sha256 "5bd6a8d895f4ba90a175f5c2fce4053e61d79b3a6abfbf9f995a6c7350d75e95" => :el_capitan
    sha256 "f343d64d718e0f3ef175e89eca31879ec65b1f7c230a819fd0f09406901e7e6b" => :yosemite
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
