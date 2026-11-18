class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.4/src/haproxy-3.4.8.tar.gz"
  sha256 "024bd521a6cbbe32b426853147e6bbd6a89b107c5a34144846193fee5b7c6ed1"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "02c72e4608eba95a7da05f3e3bc105c8e6876c4ec8c64027f0fe3dcd764f3e19"
    sha256 cellar: :any, arm64_tahoe:       "f61f47ae57381eb13816730780dc18aac0948b8a6e745c8872c6fac1c587160d"
    sha256 cellar: :any, arm64_sequoia:     "355c15941ae00b67873c95751eb8b958f70f1702608124f36753e5771ee12f67"
    sha256 cellar: :any, arm64_linux:       "83b6c27494a9c29a671e724d574b0702ccf610ea4e026b76bfcddf71caee97b4"
    sha256 cellar: :any, x86_64_linux:      "a98f34d24fb305358b7ebe721787cb6e8cc5e3dd6a93083f49a12b031fb4d674"
  end

  depends_on "openssl@4"
  depends_on "pcre2"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = %w[
      USE_PCRE2=1
      USE_PCRE2_JIT=1
      USE_OPENSSL=1
      USE_PROMEX=1
      USE_QUIC=1
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
