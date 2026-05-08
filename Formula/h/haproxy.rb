class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.3/src/haproxy-3.3.9.tar.gz"
  sha256 "f31e8e68db077cc0956f4ed3ff7a1ec637aa5e348c6d1c5cd2163e7afeb1b9e6"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a6d631400bcf7cfa9b66611be2347d5738d6a289f831af27e1edfbe54abe88db"
    sha256 cellar: :any,                 arm64_sequoia: "69f37b30c4d003082fb34243bf4f5c517aa55d7f24b1a37426ee2fa6f5498fb4"
    sha256 cellar: :any,                 arm64_sonoma:  "55aa1a6df945d67bf32a1d74b58c56d75bbfea08181ef491c664c4d673cf0d62"
    sha256 cellar: :any,                 sonoma:        "6f12d61de1c65da96b83db6f114cecdac4b34775a425ee1143426b33b45fbcc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "950a129107c0c62c16c30e9900d6289035dfacfeac203b07bf5b37ec3ca8d9d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a4ea63ef2d56c805c55407a710ff3ca4a64ef1fb0d65b8267cdeeab74c05eaf"
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
