class HaproxyAT28 < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.23.tar.gz"
  sha256 "a2fd63810a4d46575fe369ad9d120e7e0c0f781546bc06db250a16f80abe282d"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://www.haproxy.org/download/2.8/src"
    regex(/haproxy[._-]v?(2\.8(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8a1e04d9699f26e45d6a4b268e993f22e243c3a37156e2148e703182807a772"
    sha256 cellar: :any,                 arm64_sequoia: "a6054ee155a63589345671d10211b54eb9f05779c3d9f81850ce23e76b941bd6"
    sha256 cellar: :any,                 arm64_sonoma:  "eb3191893a2ef8a538a87d4a73d3f4e8dbad63a8cf5c26531c91307646c0e7bc"
    sha256 cellar: :any,                 sonoma:        "aa0a4d4c866c2a3bab74c22e8b846257811d98fa511d75a322a9ebb8e80313b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b3e0f1798271afc3c5f611655a18e4234709d049fdea64a2d730e158934a040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a88a7c9e44e4b55591920083359b7556d89367d13d8d0adb7131d0e2943bc23e"
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
