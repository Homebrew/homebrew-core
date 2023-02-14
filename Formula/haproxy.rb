class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.7/src/haproxy-2.7.3.tar.gz"
  sha256 "b17e51b96531843b4a99d2c3b6218281bc988bf624c9ff90e19f0cbcba25d067"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cebd0c0fe3ccb11a33309512d68f34af59bb10ba4866d99df36e9094ef47e1a3"
    sha256 cellar: :any,                 arm64_monterey: "5792e214a655368e9e4f5ea822b5128cbf1f3a3277c624e54810f474ecc73a9d"
    sha256 cellar: :any,                 arm64_big_sur:  "a59e87fe0c47e7279ac0b38b860a130644fb1f87a5ad8c2b33cd47589daad07e"
    sha256 cellar: :any,                 ventura:        "86188e40027495b195583768bffa220b9166d9b66ffd6ce7ec6267d8e390c90b"
    sha256 cellar: :any,                 monterey:       "11b1cc4cf1c8673a5c2caedd2cbb1600b9a071e57c3b25be751db8ab73de8a08"
    sha256 cellar: :any,                 big_sur:        "41275f52d7b357d3345ab74797d90534a3a989afcf2d9896e13ceb01eb052a35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8272351370eda885e6e1c3c4f7608c45d993d2dccf86721f4cc3c42849d3a033"
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
