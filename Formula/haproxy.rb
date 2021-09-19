class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.4/src/haproxy-2.4.4.tar.gz"
  sha256 "116b7329cebee5dab8ba47ad70feeabd0c91680d9ef68c28e41c34869920d1fe"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "e1e24392d118cd35036025eed2656a67a60d8186186223f1f905f2eff9dc28b1"
    sha256 cellar: :any,                 big_sur:       "1c67308e8de1869bbe5c923e29ace14f32c28741086221a5853584be0438be21"
    sha256 cellar: :any,                 catalina:      "94a4dfcd3c2b0cf50ca476ee6c3eefb09e603d9305bf4353b1589c0aa530a57b"
    sha256 cellar: :any,                 mojave:        "3c51e2be80e2f57948ff6d23b8b954e7a32261b57d3da3e136b2367b5d2a760e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7c8dcf12200833be51a117599d05325d69a384646a31695cff659d43f2450f4"
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "zlib"

  def install
    args = %w[
      USE_POLL=1
      USE_PCRE=1
      USE_OPENSSL=1
      USE_THREAD=1
      USE_ZLIB=1
      ADDLIB=-lcrypto
    ]
    if OS.mac?
      args << "TARGET=generic"
      # BSD only:
      args << "USE_KQUEUE=1"
    else
      args << "TARGET=linux-glibc"
    end

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
