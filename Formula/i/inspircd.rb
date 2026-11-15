class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/refs/tags/v4.12.1.tar.gz"
  sha256 "d88d16014349c572776d5dc0a55e4b28e61caba857b5fbee47c3a49ca1591fef"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "571a5b84e86976e9a0ab09b5efd3f32435526a44e1a2c20995cda7c311c32392"
    sha256 arm64_tahoe:       "ba6c86f25072d65436df028966ea2bfa8910f691f76a2efb6d546e9dab822ff5"
    sha256 arm64_sequoia:     "a28301bff1f58ae22e48c0d2d8ca2c0853a17a157acbb7bb24abf34a8c4dd5c2"
    sha256 arm64_linux:       "44eaf2f3ef4dfe300248ca50c8fa23c99ec9809137cc55863fb738ca49d3815a"
    sha256 x86_64_linux:      "e1c9ec5a111bd35a4ef01f9b40b7ed66af370127d62ab59dfcea9b371ffff118"
  end

  depends_on "pkgconf" => :build
  depends_on "argon2"
  depends_on "gnutls"
  depends_on "libpq"
  depends_on "mariadb-connector-c"

  uses_from_macos "openldap"

  on_linux do
    depends_on "libpsl"
  end

  skip_clean "data"
  skip_clean "logs"

  deny_network_access!

  def install
    system "./configure", "--enable-extras",
                          "argon2 ldap mysql pgsql regex_posix ssl_gnutls sslrehashsignal"
    system "./configure", "--disable-auto-extras",
                          "--distribution-label", "homebrew-#{revision}",
                          "--prefix", prefix
    system "make", "install"
  end

  test do
    assert_match("Cannot find config file", shell_output(bin/"inspircd", 1))
  end
end
