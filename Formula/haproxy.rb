class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.6/src/haproxy-2.6.4.tar.gz"
  sha256 "f07d67ada2ff3a999fed4e34459c0489536331a549665ac90cb6a8df91f4a289"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "48d95bd29f0c0976d599b0d54eea400304a33d223e5468ca757bf0ac5ea447fc"
    sha256 cellar: :any,                 arm64_big_sur:  "c0f409b60287184034583cea1dfdade247d3b1a3315a92ff1d294ee305e58223"
    sha256 cellar: :any,                 monterey:       "17dac225853efb6e63f015cb0b01f4bf667f975834b5e237c904c49ade0a12c9"
    sha256 cellar: :any,                 big_sur:        "5ea009640337928aad0fd5ddb44170b1ebb640838163b0bafad87a44b5b6be4a"
    sha256 cellar: :any,                 catalina:       "d7fd0e8167c1cc8750c10dc1ea5ea40871135c15216d77ce6bba87eeb44eb0a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61797b0d3a5fcaf66b3c5e77df5cc238c5d95fb946ffee1888ef616da372dba4"
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
