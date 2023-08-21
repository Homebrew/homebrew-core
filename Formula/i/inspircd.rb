class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/refs/tags/v3.16.1.tar.gz"
  sha256 "cee0eca7b0c91ac0665199fdfb8ed4edb436a08b8b850b35e19da607c102aec0"
  license "GPL-2.0-only"
  revision 2

  livecheck do
    url "https://github.com/inspircd/inspircd.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "92d5e017500e6aa117228cbc4a32ce4be5b149a9535fab37b47229c0e028cee3"
    sha256 arm64_monterey: "e7d563fe892eca1b101690339da51f461f5de735d866112e7093c6710ad4953b"
    sha256 arm64_big_sur:  "d10b1d9cf2f7057e046458a66970a6ab0839e000a84e8a0ab7064801b12ac388"
    sha256 ventura:        "d5e96be099e170d176ca0c242da8b3cd669f692e4034c48a75eb23301c5a2601"
    sha256 monterey:       "fcad290de03fc60f5f3adf9a5bb6d50ea7c7f600282e57d24a85fffa1643370d"
    sha256 big_sur:        "506584211e07943fb2cd4c2c0d91dfe6200d72dbfbd3cfc44041bbbb34d0ee77"
    sha256 x86_64_linux:   "c021d34c17eb6e26c488deffc704ccba01508312ddad7e6f24b93acdade1129a"
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
