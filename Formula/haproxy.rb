class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.1.tar.gz"
  sha256 "485552fcd9d5d5f41aad046f131fc0a7e849bef25a349a040750af0c6fc56807"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "22a59ed6009f6292d5c6adabaa5e0816da360dba900cb67d6b1696f180eaefb6"
    sha256 cellar: :any,                 arm64_monterey: "5fc0bf52540e0e94139e4ecfb1ef82643b2b609f2daeb8c13a2cc2499fe7a7f9"
    sha256 cellar: :any,                 arm64_big_sur:  "dbb3fa4e55ef36f3c072e16a8ad645484a9eeff81fe18d0a87dd783e984364b1"
    sha256 cellar: :any,                 ventura:        "f455398937edac923b268e0e189c633aac8459ad20fd5fa6e769045615d3e7ad"
    sha256 cellar: :any,                 monterey:       "15d31fe2ede907d058a66e47f1ddd5433b75b1d11d24830ffe11e77b4ed63790"
    sha256 cellar: :any,                 big_sur:        "c64e3ab6347d3b540453a2f9bfd65ef551d62136153540fb72cb37e5ce1b8313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d130c39516d6a69311bd7e1b5a84c4ae04c0e39d76aa1685fce7b26bc6615b6"
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
