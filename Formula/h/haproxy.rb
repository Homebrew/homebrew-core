class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.2/src/haproxy-3.2.6.tar.gz"
  sha256 "ad630b6b0b73e1d118acce458fec1bf1e7d0e429530f2668ec582f4f8bb78e65"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5e798125554232f4a4557a0783f70031e6288cb4f5d230d054f7f5d467ff091f"
    sha256 cellar: :any,                 arm64_sequoia: "faabc9229584448d4d49c78ac3324a6e8d28df678f9922de39ec2f7838a73434"
    sha256 cellar: :any,                 arm64_sonoma:  "010df7539f5453f40d148d8afcddc86da244cd07cb92cb70b929bb97bf499f18"
    sha256 cellar: :any,                 sonoma:        "50a7af448af08f72920e8f4ff54a9df518536820fd23cdcf459ce90dbad04f3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc89a769b79e2fa174685f02956a6877603c9f57d369e30da79a74b8612ccd18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8db652fad6f86c6d0422de36cd368ef0e1d4291abbc4d021532e97c72262d6b2"
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
