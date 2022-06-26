class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.6/src/haproxy-2.6.1.tar.gz"
  sha256 "915b351e6450d183342c4cdcda7771eac4f0f72bf90582adcd15a01c700d29b1"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9c3d8be2493d4c57ce6e12ce1d3eea9c1c957d5558743a79b23fb9900663eaf3"
    sha256 cellar: :any,                 arm64_big_sur:  "439bd181139a39f81d6ea5cdbf3e1d2206431a5cf28de0f5b97db052af220445"
    sha256 cellar: :any,                 monterey:       "69151ee0db7ebc89735ff0ffe2d3ebe0fdcc2419916f1f011b19ba47ac78aa5d"
    sha256 cellar: :any,                 big_sur:        "832d8cc9e492a8473f81f94a8a6c2deaaad8f39315ad8118c1a69b2140460b94"
    sha256 cellar: :any,                 catalina:       "272cf47d74b49217f208b0099fd268c9da1ce39d86878e019c71326e6aef88e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25e2ee246c20b103e12d65de243b442fb008526c40b903ec5ea3aedef2136314"
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
