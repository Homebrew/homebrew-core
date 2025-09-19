class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.2/src/haproxy-3.2.4.tar.gz"
  sha256 "5d4b2ee6fe56b8098ebb9c91a899d728f87d64cd7be8804d2ddcc5f937498c1d"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7161deac7a7c02daaefc9a2b14169f248db5e723b17dcf4309bb9de3b6038f44"
    sha256 cellar: :any,                 arm64_sequoia: "00b187e8bc5aded4b6d579665780a0a72009bb092ef9900965f63caf61dac17a"
    sha256 cellar: :any,                 arm64_sonoma:  "2937032c3067d621a6182b778eb55b77df8ef25f33641eddd932e44f4593f9e9"
    sha256 cellar: :any,                 arm64_ventura: "cf87e4851c5fc9d501b8ed7db1deb8e4791c5553cc596cf527eb0e16f0b1d1ea"
    sha256 cellar: :any,                 sonoma:        "64567802df5608b27da5e595f77ab2033f70b3a66e8821d98f9dd0be6c3030ed"
    sha256 cellar: :any,                 ventura:       "fbd7e468dda2ad07c00034f2b5cfbbbde6c9d7db05094008d145a2eedb397e55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a20b787fe02e6ee68e69bee4c33465411c977de8b5a99e20745e3320664ef59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "602ff1eeb6c53e788b15da9500646473907d6196a2eb553ce2443095b7cd404b"
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
