class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.9/src/haproxy-2.9.1.tar.gz"
  sha256 "d5801c772aab9c43f40964b7b33b4388d14b5b45750be4d2671785863cdb9f1c"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8f68d9fa4dad90a95b404dbdf745a16af6ed3fc13ad170c814c8543ec8a53572"
    sha256 cellar: :any,                 arm64_ventura:  "d279116bff1103453ee276ba84af11fe72336fbc7a705266647096cf61b2a448"
    sha256 cellar: :any,                 arm64_monterey: "fd466fbd384a8f447ab8ef8cc1f70d3eb274bbe2dd46bfbc161be2dafe1645be"
    sha256 cellar: :any,                 sonoma:         "fef7117e13ac638ed53306195e2aaa27cefbc4252083e10fa581984209d5e65e"
    sha256 cellar: :any,                 ventura:        "0160c86c154ab885ae0d37d9dacc5fc9c31f70da1381ceb725c4585151f6655b"
    sha256 cellar: :any,                 monterey:       "6c6bdf0a9f481ef26a3dc4780ab9549b8ce9dd1b3f6656cb2748a2cd68fdc610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29d83e67f510f786a36e64258fb44a6cc8a5162a109b6bf57308f26f0a763053"
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
