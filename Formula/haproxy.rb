class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.4/src/haproxy-2.4.2.tar.gz"
  sha256 "edf9788f7f3411498e3d7b21777036b4dc14183e95c8e2ce7577baa0ea4ea2aa"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "9e19720dc2e785352b8be41e9e575140fe9b08e86e840f169dc9342aab4a143d"
    sha256 cellar: :any,                 big_sur:       "14b0514e6083608c17237344ffab08916e7f9e527d1ad6e9b13a8c537f838534"
    sha256 cellar: :any,                 catalina:      "467226745efdb18ca77c213c26f6ace96244f02f4639a37e0e9f522ca26a7853"
    sha256 cellar: :any,                 mojave:        "6c5cc529aa7ce7dbc53095e4dc540cb0d214f7bdcbf26a754eb0b3816a807fe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c3ee57c4efb9759e553d1cfd2cc2119745a68028212229e460e83aa17a1f677"
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    args = %w[
      USE_POLL=1
      USE_PCRE=1
      USE_OPENSSL=1
      USE_THREAD=1
      USE_ZLIB=1
      ADDLIB=-lcrypto
    ]
    on_macos do
      args << "TARGET=generic"
      # BSD only:
      args << "USE_KQUEUE=1"
    end
    on_linux do
      args << "TARGET=linux-glibc"
    end

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", *args
    man1.install "doc/haproxy.1"
    bin.install "haproxy"
  end

  service do
    run [opt_bin/"haproxy", "-f", etc/"haproxy.cfg"]
    keep_alive true
    log_path var/"log/haproxy.log"
    error_log_path var/"log/haproxy.log"
  end

  test do
    system bin/"haproxy", "-v"
  end
end
