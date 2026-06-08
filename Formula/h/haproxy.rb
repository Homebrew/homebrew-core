class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.4/src/haproxy-3.4.0.tar.gz"
  sha256 "9298f565c2a9ba8a4e7f89c54be2c5d3fd960b5b304eb5515e15d29d2c15d4f7"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "014116c8cf8dd7c073c2ad035c3bd0607aed55d3d1911595d20afb97764168e5"
    sha256 cellar: :any, arm64_sequoia: "a356c66b8f4481d52fca9a715c172b1317bfe4a7f3393afec56631805fac73fd"
    sha256 cellar: :any, arm64_sonoma:  "89972e062bd49cce8fc5baa3c914dabb50b9e04311df7009e6c57ef51c60cf05"
    sha256 cellar: :any, sonoma:        "60bb54f29fc3178c834c49ac8ff0daeea10ea5654e0328f7248f1e09388cc7c3"
    sha256 cellar: :any, arm64_linux:   "a70af3778e9bba45c2cbb863334ffc412f6ba27a2af4edf4ca490599538ae33e"
    sha256 cellar: :any, x86_64_linux:  "d94989f9d6574632db9284e442e6fbd62aabfbf134234284fe8f176b5382c8d9"
  end

  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
