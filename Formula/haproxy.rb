class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.6/src/haproxy-2.6.2.tar.gz"
  sha256 "f9b7dc06e02eb13b5d94dc66e0864a714aee2af9dfab10fa353ff9f1f52c8202"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ce699e54598abbe884b1326625ac58e0fc5d8b937f35d00577c7d85058e1d74f"
    sha256 cellar: :any,                 arm64_big_sur:  "f3ea9f1ead7566b41bcb913b7a2e1aa01c09494a95ecca6120367c659bf115f5"
    sha256 cellar: :any,                 monterey:       "b9e4d3b060593fb08c10a3c77cee9e5eed4394577043b6fd304b8e39da4e2858"
    sha256 cellar: :any,                 big_sur:        "64215450947f19c3a5e90e6eaaf49e04512817684a32a0f6cf3f4da274d7c070"
    sha256 cellar: :any,                 catalina:       "9f059611064561810b2fbb1b8112a4e455ece873a42c072375aa96cbb1d75fc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14d7b508516b283b4517c58e3ac0ed05e50c115e037086fa1a63937938df9e85"
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
