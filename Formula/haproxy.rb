class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.4/src/haproxy-2.4.2.tar.gz"
  sha256 "edf9788f7f3411498e3d7b21777036b4dc14183e95c8e2ce7577baa0ea4ea2aa"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "b54672fb0fe03ae0fa691a09c113f2d9fa6a761f0a903a34b0c59deb8cf154ff"
    sha256 cellar: :any,                 big_sur:       "7ab9db1ce2e05d9dace25c3326f3c01d08c7e68141d085d4dca532260b7a2781"
    sha256 cellar: :any,                 catalina:      "926b05c986b62dc851359aaf0e327b77608bb71c2222570692d4733d7f935726"
    sha256 cellar: :any,                 mojave:        "b98c7e96b60593cbe645a1840f5ccb82d8e253cc4e208d243920c92b303feefa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13af7cb7dd5051248675a343830d72c2be49a33cecd3a9c08472cf84e6674d8e"
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    args = %w[
      USE_POLL=1
      USE_PCRE=1
      USE_OPENSSL=1
      USE_THREAD=1
      USE_ZLIB=1
      ADDLIB=-lcrypto
    ]
    on_macos do
      args << "TARGET=generic"
      # BSD only:
      args << "USE_KQUEUE=1"
    end
    on_linux do
      args << "TARGET=linux-glibc"
    end

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", *args
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
