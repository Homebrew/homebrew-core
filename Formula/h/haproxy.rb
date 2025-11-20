class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.2/src/haproxy-3.2.8.tar.gz"
  sha256 "46703fb94720f92cce2b08049a40d9176962037ba676885c55a56bd9d625e7c2"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ebdc1f4fe84c98928fbb8a9efddec0fcf64837bbb2623c129d8f01b35291c701"
    sha256 cellar: :any,                 arm64_sequoia: "39316acec43f5aa277cfda96a28dfb509b95023775b5e51ca4138b46a9db05fe"
    sha256 cellar: :any,                 arm64_sonoma:  "41e881fa9ec50d80fd28b8796ba0693683d6691441ce2628952938c7b13d23f0"
    sha256 cellar: :any,                 sonoma:        "3b559716caae2c5c6d9e82bdb808b37373c8ce2dc20d78938323d4f2ef5380c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c19265c95f4307e938a6daf049d75fd37459f861950260478f9e1e078899d5e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7e10cb0a0077c210d2fcffc4c68713ae0bee47926cb7be1f7b948568b053cac"
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
