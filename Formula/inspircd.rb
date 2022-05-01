class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v3.13.0.tar.gz"
  sha256 "0a4534114f5db1602c53ca4cfbb5ad623b9f990737d8c8f85890d8de47165729"
  license "GPL-2.0-only"

  livecheck do
    url "https://github.com/inspircd/inspircd.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "07ba16eb870ec79b637c305a4e3ad7f76902b5868719e8fae89efc97a693a51a"
    sha256 arm64_big_sur:  "5dafaba3e847c46aa348be373a747f31c320f085dd88ef4077dbd12a7d919fa1"
    sha256 monterey:       "0def0c066a3ba7c3c38a6f647666b17ee4aa25933eda77b0e6298eb091237216"
    sha256 big_sur:        "4048920d44eea13f78ce8be07d4fe72505d7b044d19b9f2e9099b21b0137f85b"
    sha256 catalina:       "3aa1b15c4cb75d75003863dacca69bc8ef4a163bfbf906d9f630287095bc2c7c"
    sha256 x86_64_linux:   "c662dcee44d5dce1b563e125960371a2268ba711da2bc25412ad7bd4a2d8e734"
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
