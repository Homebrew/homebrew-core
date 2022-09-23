class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.6/src/haproxy-2.6.6.tar.gz"
  sha256 "d0c80c90c04ae79598b58b9749d53787f00f7b515175e7d8203f2796e6a6594d"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "12f33ac2ce6ab0aadf11f2842907b2e421b67a44e25201b0746ed12256c07ead"
    sha256 cellar: :any,                 arm64_big_sur:  "81d7c3da03281fc8db48e3dcb5636d58c46a10d3615d99a4074c9f264364f936"
    sha256 cellar: :any,                 monterey:       "6ec1043a1405afca04f5d16a08a4130a9a99a9667eb18e299fc708fca804e384"
    sha256 cellar: :any,                 big_sur:        "b34969f1481e9277061c48c7045bb68a1cdb5925d1a43dc60eab92b8baeb62ce"
    sha256 cellar: :any,                 catalina:       "1ca88b37fcb9d78a1736b929ef8609863c9e87a5c0e05ef8d5543de7ec683030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e468d55a6e2734f378754135e9543043b9bdf799fd83aa5746e5793c98b3b94"
  end

  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    args = %w[
      USE_PCRE2=1
      USE_PCRE2_JIT=1
      USE_OPENSSL=1
      USE_ZLIB=1
    ]

    target = if OS.mac?
      "osx"
    else
      "linux-glibc"
    end
    args << "TARGET=#{target}"

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
