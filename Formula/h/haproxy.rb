class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.4/src/haproxy-3.4.1.tar.gz"
  sha256 "2e62c4ce4fd77d3bc7cf17e586431663454456a078b7c8465b8f0125b5bc22f8"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1a37c77ff0c3adda948584e00fe414c5d06fe0dd0c36e67991da770d3006faf6"
    sha256 cellar: :any, arm64_sequoia: "eae47d23628f39762ecd90adf72d5478a15155c6da021726f638224d8baed86c"
    sha256 cellar: :any, arm64_sonoma:  "dbb44598ac9d08b73d598234e76f211fe7795995209af3a0f0a76101bd0fa2d3"
    sha256 cellar: :any, sonoma:        "999b2fda7cbcdae053d8e38e37dd693d3f3ef5f7b4104471c6a5d0217e6259b9"
    sha256 cellar: :any, arm64_linux:   "f819045b14b4dfc61f893e59efc10f1e18275ffb35ba238e0ae3119e258488cd"
    sha256 cellar: :any, x86_64_linux:  "1eb618aba0a3b78ae19cdce14db36894befab58413006039be06c45da7b03ba6"
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
