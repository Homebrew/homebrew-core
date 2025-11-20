class HaproxyAT28 < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.15.tar.gz"
  sha256 "98f0551b9c3041a87869f4cd4e1465adf6fbef2056e83aabea92106032585242"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(2\.8(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9adcffaafce1e1ac90f0297cf3d6ad730510559c5d423ffacaceee35592a0fdf"
    sha256 cellar: :any,                 arm64_sequoia: "9c2974edd35e97688c43cc7d2eeb05f99d7d1e77d4775b75252f0596c7d3be38"
    sha256 cellar: :any,                 arm64_sonoma:  "8d88b51a5bdd02a5ad295a62798be487f2402449da9a00d3a1e894fff2e98760"
    sha256 cellar: :any,                 arm64_ventura: "e48343df1514212e3befa265ef2ccff16f0a8895ec0e19bb6f92edde2bc6a62a"
    sha256 cellar: :any,                 sonoma:        "f68328ce7705a4ab218a7d9a4242be1a48e5f130727d4d0cbc31c473508ed6be"
    sha256 cellar: :any,                 ventura:       "cbbad755a7f67a6125833975e7c774175da4c01ca7fa60f1e1ae78e14cad7623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6afa3c123ad4870ee3d15c19ac44d3d586a1f8120ee1bad07f6e0874ef445450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afe78555e84ac066998a7016ff4448317b992fe410a9046ce065d0733c268559"
  end

  keg_only :versioned_formula

  # https://www.haproxy.org/
  # https://endoflife.date/haproxy
  disable! date: "2028-04-01", because: :unmaintained

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
