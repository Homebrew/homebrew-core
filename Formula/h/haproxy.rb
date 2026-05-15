class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.3/src/haproxy-3.3.10.tar.gz"
  sha256 "6aa919a13f3a575416ef0ae45da0ecb35f1a8d004641dd684fe9b53e646891f2"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "271aee42db7a6a6810b1be8290fc2fcc291cc0e2ce8f481337124201815e433c"
    sha256 cellar: :any,                 arm64_sequoia: "9e0fdee9436f0a723d86ce0d01a4d4a7489f0fbe815517e1616c4ebeb90629e7"
    sha256 cellar: :any,                 arm64_sonoma:  "7b26c71d5604b98c145b326fd3eb92d0f8565693642791885a278bc840fc62a4"
    sha256 cellar: :any,                 sonoma:        "4e9f3d410c272da769ee9e8ac74d374f959b8fd42e423cecc8d008bddc13d286"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb30fe4a32cb9a59c51bf5495d43aee5cb7281ba888d40604f12260a19fccb34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "687dd3d5edf6bc71acb6b1d4b717aada67ea42813c12cf7577753fb6bc368aa5"
  end

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
