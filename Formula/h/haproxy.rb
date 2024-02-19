class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.9/src/haproxy-2.9.5.tar.gz"
  sha256 "32b785b128838f4218b8d54690c86c48794d03f817cbb627fb48769f79efd59b"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "23eb66d463c4ce23761bcb00e6be0bd2664ba17e513e07c0a2b592f7bde5aabd"
    sha256 cellar: :any,                 arm64_ventura:  "a88d8053cc2f73294c4b6d014b9e22a924902539ce5b428d032a6bb8a5b4980c"
    sha256 cellar: :any,                 arm64_monterey: "e14508d4b8909dd18de4a0f002e47c1bd65e85f52abbc507a5b447586eee8387"
    sha256 cellar: :any,                 sonoma:         "d928d44a5872c0e4b87d58b101195d6c721f47a83eb8ca6c72fc6da7cff9abe3"
    sha256 cellar: :any,                 ventura:        "923464297cdfada1c7151041b773e9d2709a2dc942e90155f003ea03276468b2"
    sha256 cellar: :any,                 monterey:       "cf72fcd43b1af8abe7191c89243f739bcb1cf0cafb706ee0b6d69e962e5227dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3eacab81c813ffb34ee21f8ce9a227215cdfd4b13574d1ede08b5130cdd8a00"
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
