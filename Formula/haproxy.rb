class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.5/src/haproxy-2.5.3.tar.gz"
  sha256 "d6fa3c66f707ff93b5bd27ce69e70a8964d7b7078548b51868d47d7df3943fe4"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4595ebe79f0d741dc36067018383ad58817060405bf91253f34c7b485a54d18e"
    sha256 cellar: :any,                 arm64_big_sur:  "907ee5a81421de8500db27a20432fba1a6a17b6de4360d86281c9be78fd3efe8"
    sha256 cellar: :any,                 monterey:       "777b1b8ba5cdb14c0640631349ccc7e39ad0376d339eb7daf8517e0a7c128bef"
    sha256 cellar: :any,                 big_sur:        "781457ca9161fed4c9a831b9d3d1dfdc5c02f8aedc97a3fad5938c2a91416e97"
    sha256 cellar: :any,                 catalina:       "3603585e33489dc4f31a0626737ae39f680fdb9f6db671a235177413cdd33f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4afa9e00f619abc365d72895cf4056b5f6411d40277532a0f23d5b314662f90c"
  end

  depends_on "openssl@1.1"
  depends_on "pcre2"

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
