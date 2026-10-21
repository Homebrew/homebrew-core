class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.4/src/haproxy-3.4.7.tar.gz"
  sha256 "ccfd342f3724c2cd659574044d788f44e20b212467c6bd5edbbfc517a2775dca"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "37043cc75685a8be16e999a6a73c80ed5f75a5da1a9effb76fc0ca059f729d72"
    sha256 cellar: :any, arm64_tahoe:       "3d9781307ed9181d04642bff74846cbf850bdfca6250d997046074816040cb68"
    sha256 cellar: :any, arm64_sequoia:     "d8ebd9005a2360d3043bae5a724cc17a4c265931d72f92846ed277e8c6db9951"
    sha256 cellar: :any, arm64_linux:       "fd06c122e4a38f149695153e9011ec717aa0ca50758d9f9507fd5a4c6e58c0b8"
    sha256 cellar: :any, x86_64_linux:      "d9d09e2effdf76f16ed371c397b06da7d7c5fedfbaf44c4879a8066c17b8c54e"
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
