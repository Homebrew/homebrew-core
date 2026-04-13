class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/refs/tags/v4.10.1.tar.gz"
  sha256 "c41474dd2b094e86cde6295266192f4234ce98a4c6046c827bfbd53b7bba0f77"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "05e2e4392679cef7f1c397a1d36ddfcfa8d9e4e747e39a35865154cc55a6401f"
    sha256 arm64_sequoia: "a05c325e579cf85d719e6c99f285407cd6f39951ec78ceb1916fceceb887a8f6"
    sha256 arm64_sonoma:  "920f095e6e222af7d4bb1215440039ae26d866dd8d44887bbbbef5e8a9d4fa42"
    sha256 sonoma:        "38ed20fedfde3a757f51f10a0c28e84d84523e2962af7e7d4c2121a869979c67"
    sha256 arm64_linux:   "ef6b6db7fbb173d518909ff077338b9360e79377a754bf1b32946c558c44466c"
    sha256 x86_64_linux:  "3d7af0a72e817d3329e4ff0fe56683daa425e71e07291c0b546ca78423c1b47c"
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
