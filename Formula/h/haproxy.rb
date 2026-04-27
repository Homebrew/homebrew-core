class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.3/src/haproxy-3.3.7.tar.gz"
  sha256 "c243e17281f79fa81a321e0b846ce67897315570de1b8ccff6ca6b7a312683fc"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aec7ffaf6f47f3b2890b75991ed1662d099b363919e4a11be7cf0b3225f8c989"
    sha256 cellar: :any,                 arm64_sequoia: "c64db7ba8c3aaec42e2b2ac49556e2f5dc1cdc7d1b1b11c5ad278225491e3dcb"
    sha256 cellar: :any,                 arm64_sonoma:  "afeaf62626c8c243b5bf897cf4c8a04ecb15d26da0653db5fecc3d7ef7326ff9"
    sha256 cellar: :any,                 sonoma:        "85fef64088a86cbb4566c6785be546cd18aa2193ff357b256714f7b44e98593c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ad6f96a57f9e58fdfb3a1b55e11b76e504f612ca341430ec8f521e1c313f85cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e262443ef0a6d568a0b04c325663e35f6a61ffb3bd01b4fba55a51beb20235b"
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
      USE_QUIC=1
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
