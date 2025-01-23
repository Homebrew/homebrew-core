class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "ad73fcf46665cba5d1639d3bae79766991ac4bbb2665b976c5819126c15ce6c7"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "4eb8e506c3e13b004309247ca0f3c36b88072d0ec9a51508b7517adfad249d3a"
    sha256 arm64_sonoma:  "e765ec5221f4f108d5b1d70b80928e0bd8e9488bd212ed6a7ec2be25a7b9da43"
    sha256 arm64_ventura: "7fa69834c6e562eb7fc1662f92af8ef224adb9184c5b2a68eaa6fe2373d38932"
    sha256 sonoma:        "0b3103560cc59c20b1b779fd53461c22e3da78e7328456b33a1f948523172bda"
    sha256 ventura:       "f66b6fc658dddd53a9bb51ab7c00d2a2c2a6fc8539b7faf064282cafd6eed4a6"
    sha256 x86_64_linux:  "4548d53c55c691f04dabea6ac958458a88d02b2d78bb25a066a900405ef4061d"
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
