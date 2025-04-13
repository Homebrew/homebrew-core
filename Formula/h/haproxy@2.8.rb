class HaproxyAT28 < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.14.tar.gz"
  sha256 "47984506d0cd477d5c6a7d7ba2adaf0039ca27af970bf76384855a7f1c22773c"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(2\.8(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f5873d875bc35c00f24d335cbfe667283af1b447b1a222447e64df1970da5208"
    sha256 cellar: :any,                 arm64_sonoma:  "16bb3281b6a9aab3f716d1b2dea2ea517e68a110f8397a5a4b2ca4ccd7b301ea"
    sha256 cellar: :any,                 arm64_ventura: "bb74a5c4400e20460e9d79dc3cc6f32b7c5b92a795cbe43edd333254ddccdf16"
    sha256 cellar: :any,                 sonoma:        "c24f21ad6e56859e9795fd5b3220ee10efa598b16472683fb014edce9976f58f"
    sha256 cellar: :any,                 ventura:       "04fb1ab506194389d0375df589a0f0b228332ec6589c4da459e1712ec2928a5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85428bcc7e7154455e0dc5661bd7891c00874bdee3d8b5c9ad208d4dc1c42e20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38d97a5cc12a5232baed42994505a10e7a6857635ba67669372709cc9862d2c0"
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
