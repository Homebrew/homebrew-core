class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/refs/tags/v3.16.0.tar.gz"
  sha256 "8d9e657e70f1252d9625d3d31623a56abbb3121cebf6be2f4f5791162919c657"
  license "GPL-2.0-only"

  livecheck do
    url "https://github.com/inspircd/inspircd.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "944b3368251d6454e4c17d5d87825d679d072e5b382be1ec33d924f231d6ee9b"
    sha256 arm64_monterey: "a3370879ae9f1159524faccf1f2029816d559a0595bb96a5f051ca65deed3031"
    sha256 arm64_big_sur:  "cb30dffa92d439f86774afe6a345edd77cd244cdc8aafe70302437070fe52091"
    sha256 ventura:        "0f4d2bbf59e8407778340569a83cfc262e6fd104597df1e1e9b0c70b4f21aa6d"
    sha256 monterey:       "fc7137827497c0141562dc5895a5834756852cf3747211864c3cf855723e654e"
    sha256 big_sur:        "111547a9dc368a8616baa2657a475ba6991c40bb9691e58e82648b5489e2408a"
    sha256 x86_64_linux:   "f72f89ba0acd500ed6018298a85714a49554be2fd77166f37b6603113160c54f"
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
