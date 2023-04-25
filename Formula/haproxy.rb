class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.7/src/haproxy-2.7.6.tar.gz"
  sha256 "133f357ddb3fcfc5ad8149ef3d74cbb5db6bb4a5ab67289ce0b0ab686cdeb74f"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d047eba0d976365a755a079ed54445457c9e770e912410febe8e8b24f12148ca"
    sha256 cellar: :any,                 arm64_monterey: "5e1fba963b0e2841ffaa4795d5d993b3a708d7d63c972e82806ec1a9d169e123"
    sha256 cellar: :any,                 arm64_big_sur:  "04d4f5f4de91d2e09cded470bcdc8d9ffdac6f5580ae14dd60fa8bf1dd193132"
    sha256 cellar: :any,                 ventura:        "9cff68774acc217df0988d6e05595b969aa70067b14643dda8e627696aa06146"
    sha256 cellar: :any,                 monterey:       "1d2be840d89e935d7eaad1d59070d25000aa39a1f84e1005bf428d228613e65a"
    sha256 cellar: :any,                 big_sur:        "faa7cb24ecca0d4695d9267204d42b2a3baacb53d1c7a556d5d52da673448ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7394e036745b2eee60ac70646dd2ee7203a8d57db51c2f29ec37d1507dfa5b6d"
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
