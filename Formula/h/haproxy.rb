class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.3/src/haproxy-3.3.6.tar.gz"
  sha256 "e69cb5dc59e4eb1ff72bcebf30d55f0919803c686e428c0c3a5903f2cf7c1fb6"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "19630bf11f8300bb55a3ba3fbcca86210aab593ea6676098c3f5bcdb50b0935e"
    sha256 cellar: :any,                 arm64_sequoia: "9a8d5a7272ad4c0b85423ef1e3de44f62d81ec865e289e7a849a050ebe705f4d"
    sha256 cellar: :any,                 arm64_sonoma:  "f95c2fa3ed19772e1229000226d6e0bd5e8cf44f77d5bdde004302e503af0106"
    sha256 cellar: :any,                 sonoma:        "952e4d099400bac65496c339f6d458ba94b92b10ecaf73d7d680ddae0d814f9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96f5eaa1ac429e984deba5d7358585a2b309c8d15c783b40bcf034622069e2ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c264d0f7aa95cdeb4c969595941784eec01bb5a245aa2a9ca52eb5b0121d727"
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
