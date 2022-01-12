class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.5/src/haproxy-2.5.1.tar.gz"
  sha256 "3e90790dfc832afa6ca4fdf4528de2ce2e74f3e1f74bed0d70ad54bd5920e954"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a68baa8b851e6438de690a9fc02224f10174e78b6f8d350ceb323c6f82f4fa46"
    sha256 cellar: :any,                 arm64_big_sur:  "4b1dc085aae23612c5bb209a3ebce869e2927d5aca81f75002b2be335e95f513"
    sha256 cellar: :any,                 monterey:       "b9931caaca4101872f32c0f3af1dc806e2c139836351406e97a2bd53e7952a75"
    sha256 cellar: :any,                 big_sur:        "b0d1bdc1e9c6d813c76ef8efa4e021aa2be803d331332295116a1a62c01ba345"
    sha256 cellar: :any,                 catalina:       "ccdd60fdbee3564ebe9de259df656eb8d79344e3aab1e392d8a6bc3c9ff66981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c7e6e7472fcbb8642314bd1f4475490c9a8023a29311e610795ab67f5009e22"
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
