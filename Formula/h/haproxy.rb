class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.4/src/haproxy-3.4.9.tar.gz"
  sha256 "896c55b6029ec2a841617e92a327a335f36a8968e7d51a47eada159673c2f320"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "204709bb0b47d1eb382f691b75658e885101c0ba667269b8a1cb075c95c8d7ac"
    sha256 cellar: :any, arm64_golden_gate: "d579345b14a8c8bf73389a06f910188a32c59bc4b2979dab174c1b39fd63f8a6"
    sha256 cellar: :any, arm64_tahoe:       "2f89d2de49930298447ee874607ded4cd44110551331cf6abc14ef5ff68659cf"
    sha256 cellar: :any, arm64_sequoia:     "d89ff0ed28aef3cc398f0db6bef72c9a2414d7e89349a7eab1dd4535be0be2f7"
    sha256 cellar: :any, arm64_linux:       "c6ebfe4d0f744a8b586e3f05ea01967c41bac76e5c7b4f30045cc156e9a13227"
    sha256 cellar: :any, x86_64_linux:      "d3ca12a1a435fec958093fd245cbebc5c4aa1cdd225a32977346758b4d4d048f"
  end

  depends_on "openssl@4"
  depends_on "pcre2"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
