class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.7/src/haproxy-2.7.2.tar.gz"
  sha256 "63bc6ec0302d0ebbe1fa769c19606640de834ac8cb07447b80799cb563dc0f3f"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "63b8356aef698cd0115d3095f904eb4a23d9a4a229a002a87456eb83ba239e47"
    sha256 cellar: :any,                 arm64_monterey: "3b47edd19adaf276fd234b4f61b5aaeece00fe9fab8ce233c598f6dfb395d37a"
    sha256 cellar: :any,                 arm64_big_sur:  "93e2352852e057ac0b88c974482d1c1a3f98ca70723e5f454576e6cc1e67ba75"
    sha256 cellar: :any,                 ventura:        "9080f926f20250df2832cb184cd270114006ce8da59111bb35000b00ece3a6e8"
    sha256 cellar: :any,                 monterey:       "f4fb1b42d79565bfc236fa48b00556befac320dd5dcb801a78506cdab9c19c7b"
    sha256 cellar: :any,                 big_sur:        "4de178618cc335305ff8a58c52ea82132d8284bf4b3cd796727fb5e0ca305699"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a73f570c5a8ddb6f3c14451399866f7768b954e567f9a34a60779983727e720"
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
