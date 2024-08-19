class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.0/src/haproxy-3.0.3.tar.gz"
  sha256 "39a73c187a0b00d2602cb3ffca52d1b59d90f09032734fe8c03eb2e29a7d19df"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e3c7c88571d6d3ea67a3eed3070623f02723d4da37128e4a1ab9caaadcb54771"
    sha256 cellar: :any,                 arm64_ventura:  "73097e2927579d9af76018fcd294546f551599f5a9885b5381b99b5b903ca4f3"
    sha256 cellar: :any,                 arm64_monterey: "5dff1acfb338823708e11f3263b2f8127902eecc766ce918acbf494bd32c0ae3"
    sha256 cellar: :any,                 sonoma:         "48b62918b458fa6664626d7750ed868b1c317b08c9a768e0702fbf6e8b53e627"
    sha256 cellar: :any,                 ventura:        "f0a9eb7ee68a09f8ccacd13afc655dd1c3b387807b48744ebb74f3e53f1c5789"
    sha256 cellar: :any,                 monterey:       "4f63e0bbc0291f5bb765c06eb028b70a18757709503810a32f8f717c2fa78b4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7ec19564de1697e803575bb7488e38d1fd23a4e7f40b7bd70d80a1b9361dd13"
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
