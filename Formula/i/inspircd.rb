class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/refs/tags/v4.11.0.tar.gz"
  sha256 "7f2ea0731a7e337e6ebaa1335bb22d576cba779baefaa311e15558624b5ca31a"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "61c72281c04ca2df8b6e4158224345bacd4d537299e3403f4d5687560ff6289c"
    sha256 arm64_sequoia: "9e38628375bb8aa8e01022817f106f11ca3738598b3bbc18bb032f9730b6e9bd"
    sha256 arm64_sonoma:  "f669542d5222470718d567ec98be079149b5fde12577ebb4dd3291b1d55fc253"
    sha256 sonoma:        "20fe000574784f45ae4e63998e0057e26ddab1fc482fa8d309f1059de1ed2b41"
    sha256 arm64_linux:   "cbb60a8e91bc975d0938ae8cb7c022bf7e0adee3434d2430ebc8bca2dcf672c8"
    sha256 x86_64_linux:  "beb586e95f0405d54a4d55b7bffd165d207299c443988eb9c96ca824d8e34512"
  end

  depends_on "pkgconf" => :build
  depends_on "argon2"
  depends_on "gnutls"
  depends_on "libpq"
  depends_on "mariadb-connector-c"

  uses_from_macos "openldap"

  skip_clean "data"
  skip_clean "logs"

  def install
    ENV.cxx11
    system "./configure", "--enable-extras",
                          "argon2 ldap mysql pgsql regex_posix ssl_gnutls sslrehashsignal"
    system "./configure", "--disable-auto-extras",
                          "--distribution-label", "homebrew-#{revision}",
                          "--prefix", prefix
    system "make", "install"
  end

  test do
    assert_match("ERROR: Cannot open config file", shell_output(bin/"inspircd", 1))
  end
end
