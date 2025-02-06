class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.1/src/haproxy-3.1.3.tar.gz"
  sha256 "6dd21f9a41f0ec7289650e299180b64f9dd225e35113fd1bddc6a3a2e79d5172"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c367b03c408732b11e66eb9a4d2f1f74e0c2fd562e46b363f31ccfd8952503a4"
    sha256 cellar: :any,                 arm64_sonoma:  "9d9ace614ce4bd698b2ab092737697c389c842b25debbf9dcf371c708de8014f"
    sha256 cellar: :any,                 arm64_ventura: "597806f53f50565e3832ee67ff24091cd99b8b590e8e2ff12c0360f5cbb1ccf2"
    sha256 cellar: :any,                 sonoma:        "61e296052ac70dd63eb4432c91e57918b515ed94abc33913cbcd5f033aed9e72"
    sha256 cellar: :any,                 ventura:       "7164a69a5885327a96f1a60a67ed9f87c3d39626944e70245929f026dfa77a0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "375d4d63b76fbd00aece137c7051b4aa34d097ce4a662b1f4fa8a09fd4e62538"
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
