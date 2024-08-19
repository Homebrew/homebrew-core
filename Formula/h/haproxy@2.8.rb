class HaproxyAT28 < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.10.tar.gz"
  sha256 "0d63cd46d9d10ac7dbc02f3c6769c1908f221e0a5c5b655a194655f7528d612a"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(2\.8(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "77bd9cbc82135e5a5d0ab47c0c9aea3a8ef837372616761aba88c01f1c94bd89"
    sha256 cellar: :any,                 arm64_ventura:  "50176ee8e0d5135819299f3d78e5949e9ebadcfd1f402f60ea68386b5a1adcef"
    sha256 cellar: :any,                 arm64_monterey: "bb2fc8a27835e629ef4f63e0e19016d60d379e5d2f0d09be9ed112492934280a"
    sha256 cellar: :any,                 sonoma:         "1f716dc155f9f3dcc5d0756dd9762db8529d14b97521573a0d5dba5cace62289"
    sha256 cellar: :any,                 ventura:        "f5f287a4f6645c316354aa88b863a9ed9fa6e3fec5a102ede01ca8cac2a5518e"
    sha256 cellar: :any,                 monterey:       "30eb91e3970d860f1ee79b9fa09cbf04a04934a0dcc0b05e2e3a4d014aaee5dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "124ae19c8a0ae75e1e2380482d7d69a371ffc048df35fa9d290a87f743aa51e0"
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
