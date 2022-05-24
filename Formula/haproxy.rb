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
    sha256 cellar: :any,                 arm64_monterey: "4b9fc3b432d19bddb046323c909c7dc30e04c607a847133eccdc066531eb4aa3"
    sha256 cellar: :any,                 arm64_big_sur:  "dc193cac5615c9c040bc4b407a95a9e3747a6a2d0a462bbec12bf5a649efa05c"
    sha256 cellar: :any,                 monterey:       "ba438308c678b8b56e411fa632f242feabd5b821eb1a8a0dcb282669b7b68d80"
    sha256 cellar: :any,                 big_sur:        "e675d35052f5553ad3775acc8ab65a031ba858e3946a6942dcac0f5c55a80ec8"
    sha256 cellar: :any,                 catalina:       "17609b3b7a317d15561f457ecece598080ab94fc1dfd1e4282d8548d9b8d7b93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94d6e9fdd1c6a3f9d55af123e36f7f3b6092aff089dabb4bc5a214bab27fbb88"
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
