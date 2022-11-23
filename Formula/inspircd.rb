class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v3.14.0.tar.gz"
  sha256 "e7d92cb138f5e0eb39acc3dcf459c9e65d33315a879a8910d03be8c26b1edeb1"
  license "GPL-2.0-only"

  livecheck do
    url "https://github.com/inspircd/inspircd.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "90863492d87e3d820958780b82e54f28033df2a0b7069513e55c00b0a42f7103"
    sha256 arm64_monterey: "a36480d741e6c9d5c82b04db21a0d897eb8f814ebe84fc347cc0f93eec9455ba"
    sha256 arm64_big_sur:  "c9dbf6c3bf58f439f0de1213ccd7040e4c1d4a9b8a1ddf3ed3a7ee393e991b31"
    sha256 ventura:        "90885c177087e11c332457822fd7a21f2a4509a9eabb29a428fb183dfbcadca4"
    sha256 monterey:       "58c63fc7d11e36a96a193b0f9b4860a94ec5a2314a7637df8437499dcdaebd08"
    sha256 big_sur:        "6d4bed11f56f1dfe44a3dfb983a4b29885d8edd146523a352dfbcb87ae295829"
    sha256 catalina:       "064fd95d7b73359089b4dbff19e768a58aef7b36caff933781cf67ace3a94583"
    sha256 x86_64_linux:   "28a436031a398bce877316aa7aa9d3fce0f2c08520a81b3ad8d1d8a4bb54051b"
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
