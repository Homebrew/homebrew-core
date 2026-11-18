class HaproxyAT28 < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.32.tar.gz"
  sha256 "a2bfd7dcdaeb75aa55ff15d3b9f698c4469c76a5f4a8a43a1e70df4d07acc66b"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://www.haproxy.org/download/2.8/src/"
    regex(/haproxy[._-]v?(2\.8(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "55277849f9f3788410576503eaf92897be6d697006d920849b95a84fe0ac8506"
    sha256 cellar: :any, arm64_tahoe:       "8215ef86b32fd7949952e43d8b306432899121923d8ed395b8e658f40d44937b"
    sha256 cellar: :any, arm64_sequoia:     "bb742334ae6335344526df881c05b09c571cbbb0a6b0af237649f7300c66cce0"
    sha256 cellar: :any, arm64_linux:       "93b561a2c36a826c4f9b4643522df59cc2b9acad0c464d6e6bad5addd2d8dc91"
    sha256 cellar: :any, x86_64_linux:      "83e0a386e885aac3678b4b69ac6957adffd49ffb92f6df5597ca211e07f245d9"
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
