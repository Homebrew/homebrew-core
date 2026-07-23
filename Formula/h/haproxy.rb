class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.4/src/haproxy-3.4.2.tar.gz"
  sha256 "b1330dbb0d6e6bc4a72c4708a6a9e585579cd1156dfe5763c26305105bc12907"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a934002b493d0dc27a2ad7b4883d2a6288be636d1dd3badd46d36afa92f6a37e"
    sha256 cellar: :any, arm64_sequoia: "9ab7ed6c7e75cbfd7231f9f0a9d889204739b0d33abd6946cc50c6a9bd17fb08"
    sha256 cellar: :any, arm64_sonoma:  "1cea6ffb5ce4ce4a927bf9da44df76bd140b9bd51bf194e237d72721bc34a30d"
    sha256 cellar: :any, sonoma:        "05c2a2f7070d7b7c20efec4b3552ba55329a77b651bdc38b941634a8a38a0526"
    sha256 cellar: :any, arm64_linux:   "4ce462dffb4aad27b1fed1b1ad7110e138e21baf10138e8aa124fbd9f40378b9"
    sha256 cellar: :any, x86_64_linux:  "aee63a858cd11bdc9dd4b44e1b8a248ada8208f2d1b26762e556861368470631"
  end

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
      USE_PROMEX=1
      USE_QUIC=1
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
