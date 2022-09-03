class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.6/src/haproxy-2.6.5.tar.gz"
  sha256 "ce9e19ebfcdd43e51af8a6090f1df8d512d972ddf742fa648a643bbb19056605"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b71718b09a66494d75b4393c6dacdb07e1c1f6bfd7ced1fdd87e7a40e9f795d8"
    sha256 cellar: :any,                 arm64_big_sur:  "cba98f2d6871fc7cb65f08cacedb12bd41b4f06977367f27d8d115fe1eb7d562"
    sha256 cellar: :any,                 monterey:       "f430fcb02d3ae1b6d80422a3a3295d7426776d7e63131d7cdf4af2c6ef935716"
    sha256 cellar: :any,                 big_sur:        "d77aea57c608728da96f3eadca72604f1396b0981be9a9ff5fe69b162bd2276f"
    sha256 cellar: :any,                 catalina:       "6233fbfedf0b8c3bc860831d12dee3525fcdb1ddaebe13043519c2fc701e83eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "214c1442030ec00a6969539f2ad3ddcb083f7033899cbbeef0e692a8f243790f"
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
