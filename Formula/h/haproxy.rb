class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.3/src/haproxy-3.3.3.tar.gz"
  sha256 "0ea2d0e157cdd2aff3d600c2365dadf50e6a28c41d3e52dcced53ce10a66e532"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7e44780c5912753c5c8220ec83049f175f418fa54347cca6bffd34bfa46eefd4"
    sha256 cellar: :any,                 arm64_sequoia: "66cdef771c0231a7a5f61dba4de9969137e31498b9c34416201682ea7864719e"
    sha256 cellar: :any,                 arm64_sonoma:  "3da5e0e14e9a34e7f5d9f5011d9014196b180a8fc04766a33b7c65e24ceb9f74"
    sha256 cellar: :any,                 sonoma:        "a3093a4920e8d041e62651776869be9c2a955c933dc4d9e2e9bfb3246ce0d803"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fbf67d842b58dfe2fad7427c316e0ec0c7c26215cd51492cadb8ea40af91314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5356276afa958e0d12881f2ad329c8b744eea8be736888eec165ccf7358c5ed"
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
