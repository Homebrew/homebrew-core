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
    sha256 arm64_monterey: "fe66b87be5c23dfdecb0258129e988c392e2b78fa85d3f2d916d74fd201863e6"
    sha256 arm64_big_sur:  "23d268c3f11f4442f5f415844596a18dc5258e8b0d74e171507e55b6b4a6f81b"
    sha256 monterey:       "6e224ab3cba8764b0f3a3f11231dbb979e8ffcaf3ac002da36ae4391074ef836"
    sha256 big_sur:        "8b536ca9122bc746a3e7c81265e16b0177ec2cedc26f2d165a621eeb6a2c0eb5"
    sha256 catalina:       "ade550484eb9a3cd30af97213f6af0876a80f4429be22942659f4e92c7afbc17"
    sha256 x86_64_linux:   "9cf845bb42d80e23ee09b603248d586c5cbc86de3c393e3d376ba3e2e05c0ada"
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
