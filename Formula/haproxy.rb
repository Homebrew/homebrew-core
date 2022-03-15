class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.5/src/haproxy-2.5.5.tar.gz"
  sha256 "063c4845cdb2d76f292ef44d9c0117a853d8d10ae5d9615b406b14a4d74fe4b9"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fb946286f512a8fbd1e1371a108d2ee316412a66f8489783dd639a9f715a7f27"
    sha256 cellar: :any,                 arm64_big_sur:  "2d5331d141541381bc444835c6471dd4d46561328b0d091468ec35cd2f50c163"
    sha256 cellar: :any,                 monterey:       "41b176049af0b68113db233de51d9498b6c036d49f3c6513f1f19f1d32fe31b1"
    sha256 cellar: :any,                 big_sur:        "ced4bfa758dad5613ed29ef7f8bbe959e37ae8a19c07dfaefa6efd1d4b4d993f"
    sha256 cellar: :any,                 catalina:       "83e1ed73ee3b69da662fca792ec7f512c7806062bd7a0fc4996b8595788a451d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92dbcd9d806a07c1dd050efdfc153df1e0e7a32a6eec5d5087457ae82a4d1606"
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
