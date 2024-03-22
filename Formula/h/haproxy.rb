class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.9/src/haproxy-2.9.6.tar.gz"
  sha256 "208adf47c8fa83c54978034ba5c0110b7463c47078f119bd052342171a3b9a0b"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "406893bec930fedba97d55a231889679c8669e6352a4d5782bbdeba02617712e"
    sha256 cellar: :any,                 arm64_ventura:  "78d53b4c6f84fd49fa110e28e8fdd5e5adfe634105ec9d44b85860aa77a96ae8"
    sha256 cellar: :any,                 arm64_monterey: "fb8eb01f9252e3dd26f7fbbdf8987b3a93173275714421c9e2fabf608a8b721a"
    sha256 cellar: :any,                 sonoma:         "5587b93d46210fab53bbeaa7c36738089d393d61da74343ac78e584bfc217375"
    sha256 cellar: :any,                 ventura:        "13b86cf0c155c01f6190add39527259576ed7dae5c5e25bb35b4862208dcd482"
    sha256 cellar: :any,                 monterey:       "bc878fb4b6b219312c016c3af3b8455dbc6c2c589a264e57632e538045ff9afc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bb316b2c140673c7dfc18ce504e52e145ab2fc36ed80578f8a5efde7e6019b4"
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
