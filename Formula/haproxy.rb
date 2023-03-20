class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.7/src/haproxy-2.7.5.tar.gz"
  sha256 "e2c6e43270c35a4009a70052d26c1ddb90b63a650f81305a748f229737a74502"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1b89c4c3c8d57799190f49bc28311140aa3e255bef5ddb666434807edca284b6"
    sha256 cellar: :any,                 arm64_monterey: "1a42bc1123219109897829e39413dd101908df0fe069bd9b437f323d567fd511"
    sha256 cellar: :any,                 arm64_big_sur:  "5294febd777b403a35004a86261d673ebc03ccd47f956a67de71c4cb7d4a2b8d"
    sha256 cellar: :any,                 ventura:        "fee17067bb10cc5450817b51ffb5874fa5fb34b2062f4acce82a6cb9e97fde37"
    sha256 cellar: :any,                 monterey:       "d3111ec89bda46a11122978dc28df86fd9bd3e8744838eb4a813db8f41b9a18a"
    sha256 cellar: :any,                 big_sur:        "1576226a057491b6143f5da825c42a342b81f86139853478e81d6856c228def2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da17f5f5038fc955243420582b72eae381e98ec4f89aa987a95f7b0de5518d5f"
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
