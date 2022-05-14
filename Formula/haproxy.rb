class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.5/src/haproxy-2.5.7.tar.gz"
  sha256 "e29f6334c6bdb521f63ddf335e2621bd2164503b99cf1f495b6f56ff9f3c164e"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0c326a830aacd5f57e8f8ef9fbd1df2a4aa6b3ba5630682ac9d15707918b7ff0"
    sha256 cellar: :any,                 arm64_big_sur:  "9a047f0d68096c98da8dd39b1195f3949fde22ae77d3bb31a0adf8294a5c6087"
    sha256 cellar: :any,                 monterey:       "ad4fd02122073ac6f9d7184e89a87fddf5f5f549e4599fe22c4344d6232afa24"
    sha256 cellar: :any,                 big_sur:        "656aecc60891908f93130f6ee39db64ccfa26acfb03ac64f6cb74251d2534907"
    sha256 cellar: :any,                 catalina:       "74bea03b45e17d914e655f1b2b4b8a52722af56e0c59f45be52be46bf2ece1e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb7477dd16e034f7e3630b5561a942d57b39b94e4d25556731104f8b140fbc36"
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
