class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v3.12.0.tar.gz"
  sha256 "3503cd7e68764819e9d0e2a7f301bb19899a1a3633d4653d877651dc35278d16"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://github.com/inspircd/inspircd.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "b482ea556af3c350dc3b8227312f8e883f7a751952884c78c553e9884ea8cec1"
    sha256 arm64_big_sur:  "ec29f2309f31327aa68fc12f5ffe8b2c56231dab58886399ddd759c40f3348e9"
    sha256 monterey:       "e8b83e4b26e9942ee0e6b52cf7f029b6aebab6d41ab25390ca704aa1c4880f5a"
    sha256 big_sur:        "7774e0b1cec9d0facc75e33cb1a0e32e126821cf4eb1964e4e2a5b78cb519479"
    sha256 catalina:       "7cdb8110691d79209e2366cceeb4353924e8d6fc7e422d8d756b8c9217571e55"
    sha256 x86_64_linux:   "5f92f268e08a27f8013667603414a3d664d175096dfb44c1ae157b875f43a77b"
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
