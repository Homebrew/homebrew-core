class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.8/src/haproxy-2.8.3.tar.gz"
  sha256 "9ecc6ffe67a977d1ed279107bbdab790d73ae2a626bc38eee23fa1f6786a759e"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7ef38409dc9ea3d890456d238fa77fc1d60b5d5f4497f560419ae0369fc0b27c"
    sha256 cellar: :any,                 arm64_ventura:  "5cd833b575885f61ea5bfad428f69c4f6d9d2d1d61e6d1c8ea3cfd1a35208c3e"
    sha256 cellar: :any,                 arm64_monterey: "eee0b6728a8fb7f5dee3c38f3f7a15dfbcc5a3814c14ce797641a0148941ad71"
    sha256 cellar: :any,                 arm64_big_sur:  "1dcecd52ae78c30b8a7013bb89d4433dc3390949e2798ffb17f1c73c5b633033"
    sha256 cellar: :any,                 sonoma:         "765d5c53043e0d2b49b2bbd02cfd167ce7cd532375b5eafb395d807b24e3b71a"
    sha256 cellar: :any,                 ventura:        "cf3098391e26a17e6df2c79c4eefe1f5c8afcb2c4afe669f8c901bddf34a769c"
    sha256 cellar: :any,                 monterey:       "19b19134b0526c5edd47c3a47be149b95611b4c083faf297062cc357f4524763"
    sha256 cellar: :any,                 big_sur:        "dc8bb9516a621a45c3ff468eebde2a80d323ffcee3bb97b6295897f41340995a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3840d79373935a6877f846686ac13b4d2bcc8770f5f415670300eb300b8b2b1a"
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
