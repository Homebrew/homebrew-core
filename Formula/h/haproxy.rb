class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.1/src/haproxy-3.1.2.tar.gz"
  sha256 "af35dc8bf3193870b72276a63920974bef1405fc41038d545b86b641aa59f400"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "70b8e4e5020adb8d7c7fe645621f2888773433382acb520db5a9b044268fa7a7"
    sha256 cellar: :any,                 arm64_sonoma:  "519ecc15cff23deda7cfdbf16cdb7e16186fb387d7006394c9869605c9a69fed"
    sha256 cellar: :any,                 arm64_ventura: "b9baf668356db2a8fd1a43e8b7abdefe620dbffe4575e042e391bbd50a03d7c0"
    sha256 cellar: :any,                 sonoma:        "64f1e36ebf2792ccfcbe2247858237f125b0bfbfcdcf06f854781088d9f6937d"
    sha256 cellar: :any,                 ventura:       "867df7517dc9c6a4bbfc5d1bd28fe9c5b26ad10f6bfb853b514c59d79ddc15e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09494625d87f2982143765edc99e4143e12cceb3977ff0d7f99a13e9a2b1c7a7"
  end

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
