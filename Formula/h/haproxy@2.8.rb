class HaproxyAT28 < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.25.tar.gz"
  sha256 "2189aa5baba98e4cf6e9e8c0633d88426eaf3fa1017b2a6061512f11fbc6d856"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://www.haproxy.org/download/2.8/src"
    regex(/haproxy[._-]v?(2\.8(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2f5a0b4d40886ce175a0f4188d762523d37ba77339f555602f48288c5a37def8"
    sha256 cellar: :any, arm64_sequoia: "39d289347e6fc2d72eb049559a197192a5bcfd1b441ca8ea6ab284454dff83e5"
    sha256 cellar: :any, arm64_sonoma:  "de55abadacc0653faf8143c68b2fc043b2c86ada91652a19072ffba41667cdb5"
    sha256 cellar: :any, sonoma:        "d69bbc3f847192b4b5d47ba8da57f02a2490a8c48419d86f4eac931d8a382384"
    sha256 cellar: :any, arm64_linux:   "0347d12b2284cf1167ba8fa7acb9b140c9b283d4626896f5b06ece3fdea0efeb"
    sha256 cellar: :any, x86_64_linux:  "734dc35a27e46f7c3e781508b1f46a92270cf6f14370f035d1eaa06037414a16"
  end

  keg_only :versioned_formula

  # https://www.haproxy.org/
  # https://endoflife.date/haproxy
  disable! date: "2028-04-01", because: :unmaintained

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
