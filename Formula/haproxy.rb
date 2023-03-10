class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.7/src/haproxy-2.7.4.tar.gz"
  sha256 "84cb806030569e866812eed38ebd1a8ea6fe1d9800001e59924ec3dd39553b9f"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c98af81e6e62e6fb2be7524b6476547aa77dacc3627dc45dff87622764f5238d"
    sha256 cellar: :any,                 arm64_monterey: "34efcfa3becb2a23196237246a16a13911f1a4a321480848ce833af50dfbf47a"
    sha256 cellar: :any,                 arm64_big_sur:  "a9e489e3f4e89b826cdd760ea21e9a31a3d5fd95ec726f6e0415e377258e6b62"
    sha256 cellar: :any,                 ventura:        "8c9326e9b52afe924787af6bf77607c7300cade152d8de44b21cb57bb3b1f74a"
    sha256 cellar: :any,                 monterey:       "ddf3955d1a8bd1843a35aee4920221df555e5aa256cefa73424c24186fbe1edb"
    sha256 cellar: :any,                 big_sur:        "fc33543c2e74c89953d2926b1c5d7a96466e20b9db325ca3e67251bcbc5cb3be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7416b15914a0cf9174c1a9913898a44ae5897319f89a4ce32d5f0ceb48990ec"
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
