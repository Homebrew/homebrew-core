class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/refs/tags/v3.16.1.tar.gz"
  sha256 "cee0eca7b0c91ac0665199fdfb8ed4edb436a08b8b850b35e19da607c102aec0"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://github.com/inspircd/inspircd.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "36e1bf08ed3b6e5b510ff9195a3a5a744e738315290ca4f3297871720c0cde3b"
    sha256 arm64_monterey: "13461c5b2a0c267a3e33fa3e1387a89faac2a7c99906c7043ec82f6f4e6c12fd"
    sha256 arm64_big_sur:  "064f9d0d2a9f7f460a3a091f15cf2b61a35357798894b491e2c8e1aef8764063"
    sha256 ventura:        "376c231e8fd2c8a0f538974b27f2b876110fc05265694a5154e28abc79313e10"
    sha256 monterey:       "993e8e39a0c3cef513587fde5926832bc3d0f527e4b5188eae47a4ce801dee6c"
    sha256 big_sur:        "92d102d7ac66e6f08160a5ab89516a45352b1b1835991b79403201206efbd1f9"
    sha256 x86_64_linux:   "71c844eeacfb4248ca89cc6747856130c1929c8940890626c42acc5da8e21ceb"
  end

  depends_on "pkg-config" => :build
  depends_on "argon2"
  depends_on "gnutls"
  depends_on "libpq"
  depends_on "mysql-client"

  uses_from_macos "openldap"

  skip_clean "data"
  skip_clean "logs"

  def install
    ENV.cxx11
    system "./configure", "--enable-extras",
                          "argon2 ldap mysql pgsql regex_posix regex_stdlib ssl_gnutls sslrehashsignal"
    system "./configure", "--disable-auto-extras",
                          "--distribution-label", "homebrew-#{revision}",
                          "--prefix", prefix
    system "make", "install"
  end

  test do
    assert_match("ERROR: Cannot open config file", shell_output("#{bin}/inspircd", 2))
  end
end
