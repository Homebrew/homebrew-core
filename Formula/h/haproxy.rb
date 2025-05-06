class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.1/src/haproxy-3.1.7.tar.gz"
  sha256 "a3952644ef939b36260d91d81a335636aa9b44572b4cb8b6001272f88545c666"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "305d5570a4dc9718db040872e0d29b29f28cdb5459f0c53c26fc30825d05f418"
    sha256 cellar: :any,                 arm64_sonoma:  "ab0abefa8f3e367ef0ded08e18bdece2ce2c472e5ccb13a02f0cf9206dfadaeb"
    sha256 cellar: :any,                 arm64_ventura: "6477114920e1fab919475030cf1e36565377d3dfe4b1fb54990138b5246cc231"
    sha256 cellar: :any,                 sonoma:        "286e84ad8bd5e4f97ef31fff2ec087245fc0fede37aad5acc65aad87662b000b"
    sha256 cellar: :any,                 ventura:       "403c9dabb2c851b7acffd1d243f2c2ce661bb6b2e7ac1c019baedf61456b1904"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7d85e25de80e5b1e47f3ca1b86b47f03b3acee97accab7c299c0270ea552425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3efee571841ae7dc3fb6816f779ca00ab459349206a86e3dbb43a946237e9e40"
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
