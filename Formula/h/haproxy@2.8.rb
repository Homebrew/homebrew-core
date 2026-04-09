class HaproxyAT28 < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.20.tar.gz"
  sha256 "f38461bce4d9a12c8ef0999fd21e33821b9146ef5fe73de37fae985a63d5f311"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://www.haproxy.org/download/2.8/src"
    regex(/haproxy[._-]v?(2\.8(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a8632ea82d689591a8ce597053ecdb3930af4411439fc184daa2e13d7b4cbf46"
    sha256 cellar: :any,                 arm64_sequoia: "edc0e53d6ed4173e32f5bf7b5bb606b147dafadbf7bbb16c40e7f4fb16feb414"
    sha256 cellar: :any,                 arm64_sonoma:  "810959d028f4047cdad50462e5d891482af2b98032d9e88162a9d2b068feb219"
    sha256 cellar: :any,                 sonoma:        "3e4f6f0b44a3d0fe40e1513ce94bbc40c75135cd7e3c6f783af40733e039a474"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e78d0aa53a10a7ace1c92a90a014a926db8963467d503cb1420066414938d31c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "434de4f342a8a5ef931795c40322044705b56e8ae2591ea10b31ce92d3eabfb6"
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
