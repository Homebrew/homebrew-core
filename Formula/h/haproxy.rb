class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.2/src/haproxy-3.2.5.tar.gz"
  sha256 "77316a3e1b6c39245bc11ef58f4d6dadd063c014c1baec8f0d81798c519e072b"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5f3cc98804d85db70c34ffaac1543a8352d869b274fd5520fa1e6c7f0bce65f2"
    sha256 cellar: :any,                 arm64_sequoia: "4820b2fa92c4f84d8a43acc628db24bd6272e3dd5177786a57869e2c4e38843a"
    sha256 cellar: :any,                 arm64_sonoma:  "b8b87788f37995be97f4ea8b7a665a55ece96d39e0ba52c352929001fbe11e1c"
    sha256 cellar: :any,                 sonoma:        "4769845cbebcc5b8dd707f42f474305a8bfba5b0b263d28063c11b82fba4ebf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a494b7ea5b52c464cefd97cdcaf3c2dcc45d5c0b060a2b0b3f80ca95f5d3980c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50bdd03f03d167b44f439d69ac3813cfad17274c5cb00f5ab0c1f5bac12a3837"
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
