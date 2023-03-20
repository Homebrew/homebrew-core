class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v3.15.0.tar.gz"
  sha256 "c3d201dd3577917bc94257ed8aa373c24bc03c456e55886497eb87e8520f2d4d"
  license "GPL-2.0-only"

  livecheck do
    url "https://github.com/inspircd/inspircd.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "3bbfd22996bd7f07eae83de4b7d29517a63e475d1f09b98061bf10c91584479d"
    sha256 arm64_monterey: "49b4a77d9e2ac076ba57ccb0fce1755b9846ed9c1392fac4631298d9bcf1a4f5"
    sha256 arm64_big_sur:  "a202c5b6ad4b8a15ddb013e82ebd885601553e769947a93910f88ec8b08f13c1"
    sha256 ventura:        "684c6ce03bd164177e47dbd5599911058fb4fba420f387b33e7982e6be6a7e90"
    sha256 monterey:       "af356f343dcb01f0a3ecd5e8369c99898ad1567d79ff2accb690a52e86bfacfb"
    sha256 big_sur:        "680ce7f1af2d49cf63ee17174cbe39b95b31f446f9e0466e044e7dcfc4aeeb38"
    sha256 x86_64_linux:   "fd613dd9fd665d3c7de6d9bc1995810ec26940f295b346809518bf2726af63ba"
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
