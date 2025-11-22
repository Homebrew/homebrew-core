class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.2/src/haproxy-3.2.9.tar.gz"
  sha256 "e660d141b29019f4d198785b0834cc3e9c96efceeb807c2fff2fc935bd3354c2"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7ce34dd41aa284f5ca99894b162d52c40bd09e9ccf6432b0da9ab1058f08f987"
    sha256 cellar: :any,                 arm64_sequoia: "240426673c8c9956045422c982eefefd6fcabadae990e0dc0d1dda1e780a8a9d"
    sha256 cellar: :any,                 arm64_sonoma:  "bf363d945e6a27003a628a5624e2df35656abe3120e25b35f71f971ea7b929bd"
    sha256 cellar: :any,                 sonoma:        "a29210b54f1d8c683d4a7523a7497e5acc26891f3f1129460af25f54008bd550"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b952e846fd15df6acd3889fe5dd0171671848b66aef398a39252fcd436a5bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ab59f7fbdc42071cc6c34122498a55b841546788e6c79360e0de8c4d093a42a"
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
