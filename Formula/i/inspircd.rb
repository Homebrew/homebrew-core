class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/refs/tags/v4.12.0.tar.gz"
  sha256 "5eefae1428d2e8b072c530cb01a1095a811927d63749d8c073c8044842e9c214"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "6c03dde6a3bc6202967f476090d36a00f2d343107b76f3308a48c628c2300d33"
    sha256 arm64_tahoe:       "bd003904eab3958cfce9839f25d12591a981ad43552d7255c042a1fcade736dc"
    sha256 arm64_sequoia:     "ef8a67243cac1972d655f4423888afa9ec027942d5154ea6c3ef908bbcb3d62c"
    sha256 arm64_sonoma:      "c69a73458f8d1fc23648bcc1ceab2b23c6d3b722cc0a506957caa6541e00d620"
    sha256 arm64_linux:       "7bb0e57ca2ea4f5e6f773eb976fedc33ad1954c1a4e2781042f7778b682251b4"
    sha256 x86_64_linux:      "e6d6a515429f01f323065c2d27023d74db036954f5ba639517fabf804fb72a6b"
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
