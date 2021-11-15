class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v3.11.0.tar.gz"
  sha256 "ce39a15764474a8716f6dda69e4d2b890fa17a8736bcb43c877aaacc2382479d"
  license "GPL-2.0-only"

  livecheck do
    url "https://github.com/inspircd/inspircd.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "33f3cd972d8ab19d4bac2325993d190c0af3e88b9656f4637186cacb0819a881"
    sha256 big_sur:       "25ee9b4d13e8cfcfcc6e74ed5b3f936a220670a5a7220f1b870900a75f86dc2c"
    sha256 catalina:      "f0694ead1168a43f793f83ddac4cfa9e173c8a236c9fd4e5b78b2d2230a27250"
    sha256 mojave:        "b94389bfdd3396598b3f0ef09ce775540a42f0edc94618c2d56578bf9d2ec9bc"
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
