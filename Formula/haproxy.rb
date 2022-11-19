class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.6/src/haproxy-2.6.6.tar.gz"
  sha256 "d0c80c90c04ae79598b58b9749d53787f00f7b515175e7d8203f2796e6a6594d"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3b615ce41a10d34305e759a5682f5c929a451f9d8dab227dfde3d69e406a5cdf"
    sha256 cellar: :any,                 arm64_monterey: "07a8d81248230da3ed821cf92ca48d30d1671f04f860f0c19efabe4c4b34b7e5"
    sha256 cellar: :any,                 arm64_big_sur:  "e25b425534b2fb573699124b911c4d17c8272cb980e34c1fbd97925ff97169fc"
    sha256 cellar: :any,                 ventura:        "ce2fadd70cbe5a77cac739ff85b38e7e99f98bc4b43c191edfc2eedcf3f79632"
    sha256 cellar: :any,                 monterey:       "4a7621195e23085b2ce7207bcce2b339a5b84bc1ee2646f12650bdb3a1441271"
    sha256 cellar: :any,                 big_sur:        "8f4c7d5054027dbd61cbfaa5431f5589a1061ef3a8c2a03dd3f7048d4cc4ef05"
    sha256 cellar: :any,                 catalina:       "3998379a11236c30db7260e2c1054d00723f30cf5953b400ce05dbca7150c7dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5131f7e6aeea111d167e4e948243e94abc1fa4801068fdeee0693f77b1e5faa1"
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
