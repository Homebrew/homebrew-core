class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v3.10.0.tar.gz"
  sha256 "9bbf3581fc1a9443ef4c4595b208e5b8852483cb78b20fe3e98d225fa4538982"
  license "GPL-2.0-only"

  livecheck do
    url "https://github.com/inspircd/inspircd.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "b7671a5f73963019fac39b7d6f4ef92690d0f987b49a3c86e20c72207d50061c"
    sha256 big_sur:       "3dac92c86073fd5a9dc75aaa92daab2083492cae9b68f06f912332db55641e60"
    sha256 catalina:      "a20e5a664888416963f633b8d569593bde9f0533918c5c5483d8d49968a1947b"
    sha256 mojave:        "52f51d088ec0ea10bfde3f046e67e3b41cc78332a104880d8314c3f55f179efe"
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
