class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.9/src/haproxy-2.9.7.tar.gz"
  sha256 "d1a0a56f008a8d2f007bc0c37df6b2952520d1f4dde33b8d3802710e5158c131"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d0c4b1f16454320ba15389d1407ae8124c92576d5ae5f9e1dc20dd12f5112a2b"
    sha256 cellar: :any,                 arm64_ventura:  "0d8629972f8d0b319ee3709bf7965e7bd8397a50e4c8418de5191d62d14fdbfe"
    sha256 cellar: :any,                 arm64_monterey: "babbf165cbae88c637ae7267a09bd3c3d666a70d38ca55e85785f4ff48bcbc7c"
    sha256 cellar: :any,                 sonoma:         "c2d90d817c5551c70272c580a5be39dd7d446fe222b958f389db3be86a893609"
    sha256 cellar: :any,                 ventura:        "1369a1c620a2ad5f1ff1d39cf872a3d14beaf7d10482e1d94c7f9db4c29f2353"
    sha256 cellar: :any,                 monterey:       "73c947ec443559b74de98f5ec6a36eb330e5acc87e419427f6e0025fb6c4045e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1296b956e4d3c114d12f330d16c6c6ee99c601563339833c6ade0e07812de07c"
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
