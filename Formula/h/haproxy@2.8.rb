class HaproxyAT28 < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.31.tar.gz"
  sha256 "8f2dd09cfdfe42bdc982c8615e7acb858e1815b10f296dfe5560e7f314dc6c80"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://www.haproxy.org/download/2.8/src/"
    regex(/haproxy[._-]v?(2\.8(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "76f74c2a62e638291449b38bd78a470fe07fc230d36719cdb0bfc8fb3ffc0b53"
    sha256 cellar: :any, arm64_tahoe:       "c62d40851d800bc5a6374db799308bb02cbbc94e5316b92ce8a63663fd0cc25b"
    sha256 cellar: :any, arm64_sequoia:     "26fbf6c8ae9d148140114c44b7a014aee9491fd0b9176b7edc0f48673ec9bebd"
    sha256 cellar: :any, arm64_linux:       "2fd7aad333ca949bc2ae0a7c1ecb18b394fda3eec5ddca623d0365701b18ee8b"
    sha256 cellar: :any, x86_64_linux:      "9477b4b9637ae3cb19a890f384418a54b096ea22ebda443e73373d834baa9995"
  end

  keg_only :versioned_formula

  # https://www.haproxy.org/
  # https://endoflife.date/haproxy
  disable! date: "2028-04-01", because: :unmaintained

  depends_on "openssl@3"
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
