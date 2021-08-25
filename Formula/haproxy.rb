class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.4/src/haproxy-2.4.3.tar.gz"
  sha256 "ce479380be5464faa881dcd829618931b60130ffeb01c88bc2bf95e230046405"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "403746eb35c067fa0223271a2ccf809b3863c5eb4fee1a670fa2f73b8a3c93f9"
    sha256 cellar: :any,                 big_sur:       "a0040d3c7a43b6f88cd7c3f781d53836395bdd3b056ac286e4dbbb6d0b925c05"
    sha256 cellar: :any,                 catalina:      "1097602fdf302fde146b708e61b97c5bcf1461180ffffa1af1e3feecbea9fd28"
    sha256 cellar: :any,                 mojave:        "8e68913c94c421080e8fd931824add73bb3ba2e49c29ef5e82e5fa483809b21e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7af7d982e0be49774ad7dc957a213f36d004103d98b62675595183d144b28237"
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "zlib"

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
    system "make", *args
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
