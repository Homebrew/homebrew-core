class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.0.tar.gz"
  sha256 "61cdafb5db7e9174d0757b8e4bcde938352306fb7cc8ff2b5f55c26dd48a6cf7"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "31255cd54a3dc2b86b6b7b7983e4d771efccb1e47c674c2a70d97ee6eebbf712"
    sha256 cellar: :any,                 arm64_monterey: "fe82f56f5bd7435ad30912366db07857bce80fdc717dd9c6735d9b3e8a44b097"
    sha256 cellar: :any,                 arm64_big_sur:  "e02b0a211f3f5e07a3ac4145233568b0b92917871662339eb8d38c1fe1bc57b7"
    sha256 cellar: :any,                 ventura:        "0f66cfbcdc27dc2c0e75be41a430cecea99059cfe2b6798cce87bb3c6253d41c"
    sha256 cellar: :any,                 monterey:       "af88fa28624dc6702e1ecf4d458b75778a12a1f5a48e1567d95b21160f7956a0"
    sha256 cellar: :any,                 big_sur:        "5d074b5321b118e767bd1b503f4b726cc4a7b3d1359b4fde5d53148405b730cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1008be39b9289b4e2b1dd2ee3844d81d389a38d114bf194792f99de753d5700b"
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
