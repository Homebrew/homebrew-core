class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.5/src/haproxy-2.5.2.tar.gz"
  sha256 "2de3424fd7452be1c1c13d5e0994061285055c57046b1cb3c220d67611d0da7e"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6f5a2c68a1c2a521e9b4ab8c58889ddf270a382534594f02762d22d401013538"
    sha256 cellar: :any,                 arm64_big_sur:  "657528ca59aafea1fce2c29db2202a7dbcd2124e10c41df8c837a7f16daa82fb"
    sha256 cellar: :any,                 monterey:       "3ee9118eb4c9ce46fdc431d5e6e4290717e9c7f9f9f29e3564d4e8943f6448ba"
    sha256 cellar: :any,                 big_sur:        "756d658e66cdabaea0091c71a5e61cdd78e5bf488b37962f82d5596a3e8353c9"
    sha256 cellar: :any,                 catalina:       "9f67fe0bbe19578e119ef02c7fafe9961764914e836003ebd92d15f8bb0c5be9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bffefdf53092570b6327a50391f84f190a1cdc0c41ecaee65e7cfc5241d9c799"
  end

  depends_on "openssl@1.1"
  depends_on "pcre2"

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
