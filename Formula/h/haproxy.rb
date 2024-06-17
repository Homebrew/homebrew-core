class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/3.0/src/haproxy-3.0.2.tar.gz"
  sha256 "9672ee43b109f19356c35d72687b222dcf82b879360c6e82677397376cf5dc36"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b7e4ad87c53a6fbe44c37c54105efe3eac34f2d0f6bff1da5a34dcf22798d252"
    sha256 cellar: :any,                 arm64_ventura:  "63f901a60e5c8ff6c46eda9d933af172a3c1e9225f5945577ab2b6d797f033dd"
    sha256 cellar: :any,                 arm64_monterey: "d48da320e77c73d4aeacd3f1033b7ac20f99a1fb5a063062135fdcbc80e90e88"
    sha256 cellar: :any,                 sonoma:         "a30e9e557a87a074673b422c40819db6175f061e813df00774c46ac2e8d7ce2c"
    sha256 cellar: :any,                 ventura:        "2551d26a89bc05277fea465db87bf51d8b4d19c06549f475e913e7e2e01f06c7"
    sha256 cellar: :any,                 monterey:       "8f628be6956b5b32f64e2cdc6010c6c3c47bcde7c82f0b6c9c35f48aac471a11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a757ea748f76350f95683a35c393965baae14c9576642f4aa4a35e80af2a4ce3"
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
