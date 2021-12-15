class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.5/src/haproxy-2.5.0.tar.gz"
  sha256 "16a5ed6256ca3670e41b76366a892b08485643204a3ce72b6e7a2d9a313aa225"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "48a1ed81c14881aac3e60060ec6d7a412b04ff2a8bc28c6632163f53a7451888"
    sha256 cellar: :any,                 arm64_big_sur:  "28b67e055109a5c292b91971e962644a47ca70352b26d1f0613c879d11d37084"
    sha256 cellar: :any,                 monterey:       "179a3d71b7a837705e44307ce349e63e2122328ae09b0cfce4de20660bbd7b43"
    sha256 cellar: :any,                 big_sur:        "105a9ac4bc7bafc3000751a9ffd8908e53bda4571012e0ffb1d169f7e798f93c"
    sha256 cellar: :any,                 catalina:       "b6372103b1f0cba85d41aacd06ef1b82bda43fb596cd7db56820da30d43eec84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a8d1809e22454b7fd15e4951c34c501f4ec36e8171e33affde918b64d921446"
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
