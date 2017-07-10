class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/1.7/src/haproxy-1.7.8.tar.gz"
  sha256 "ec90153ccedd20ad4015d3eaf76b502ff1f61b431d54c22b8457b5784a9ae142"

  bottle do
    cellar :any
    sha256 "2e4b69f2c842fb72c2df5d164d1cff3b62b6ad3df5e4270a6c83d81ee504a5cb" => :sierra
    sha256 "63424edee76156916c80bce2492f0b2b8f74c5dbc7b5a3d0feb3c970ba8b52e0" => :el_capitan
    sha256 "7b79f966fc3bfbe1e4a10d4fcb1ff0d2fa28610b128b50141ef0af56e3753d90" => :yosemite
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
