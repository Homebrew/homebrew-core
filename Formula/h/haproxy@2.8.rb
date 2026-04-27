class HaproxyAT28 < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.21.tar.gz"
  sha256 "ff9d6c0623c430b25d8ccafc755dd12d1138c4fa7628aff6532869a01e8675ef"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://www.haproxy.org/download/2.8/src"
    regex(/haproxy[._-]v?(2\.8(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f417b530ee75fcf192cfc646ba74dcc7412e2457f29bfa7dbd7a990e7e81f16d"
    sha256 cellar: :any,                 arm64_sequoia: "9c3c9af63c883374e870d286abc01d2c7403bd18bf112423f25be298476162f5"
    sha256 cellar: :any,                 arm64_sonoma:  "3f84f782ddf87e9a4418f81029be2a9f9dccc383c2795fd0673797efab5f4e77"
    sha256 cellar: :any,                 sonoma:        "9f8ad35f226fbd5458d2844f7f40119432083c342ae58f4cbf22f0ac93d8f71d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eea4b82627aa60cf804bda8883533b84a1b479cffd5588db64c1a7903eb1c261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39fffd16e8c8b230fabcbccd0a961409a98816ecf5c0146cc40baaff890e54f0"
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
