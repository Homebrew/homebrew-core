class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.5/src/haproxy-2.5.0.tar.gz"
  sha256 "16a5ed6256ca3670e41b76366a892b08485643204a3ce72b6e7a2d9a313aa225"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4d3dc56b786ae357d367d088a4b7ff7d76b485c4659a2904e0e1fa1a4b9e35c0"
    sha256 cellar: :any,                 arm64_big_sur:  "42958ac6ee14c305fc0da4ea93681be39c19a07e9143ce7e88b58253bf5a8449"
    sha256 cellar: :any,                 monterey:       "d73895018e1ab5bc47f967a1dbc9dadf5d5a3c8b67fa011e6c8aa5762dced507"
    sha256 cellar: :any,                 big_sur:        "cf2242232f6dab6a9fe54cc98df31ac1eb0925f8fbbecf159187226a0ea7f84b"
    sha256 cellar: :any,                 catalina:       "b5e767828ef1d07474f5a7da82495ec04210da5c9e9bc77295c38bdd0a83cc93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fc76f52825a9c8100c058d059e3254eefdac63de11d5ff8d59c8030423e747a"
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
