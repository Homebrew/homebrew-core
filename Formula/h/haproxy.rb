class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.3/src/haproxy-3.3.6.tar.gz"
  sha256 "e69cb5dc59e4eb1ff72bcebf30d55f0919803c686e428c0c3a5903f2cf7c1fb6"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "eb696dd19c1edd20a6a33185ef8f8ccc5a52b4eb10c7f2ac52fdd6ab4ba6d7a7"
    sha256 cellar: :any,                 arm64_sequoia: "88243f7d4166fdba255562df749f3c24bc18881aa42a71872edc210205179cef"
    sha256 cellar: :any,                 arm64_sonoma:  "a3bf5a2ba20fe45b1a1fb9e7f9a9ac1cb8a6b296ae214d46a7dcc852cdcf4290"
    sha256 cellar: :any,                 sonoma:        "26ca34caa5ccf6ffed9b61b9e1b8fe6dd3b7f72ac67ba3838f3252d72d9462b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "998bcb15207d511b36f0ed915d34e46b475503c083eede9ddaae908df202e46a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f618bc22b2f79e17e92552da693690efba83041fc43b8ac9cfd4e25cad42135e"
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
