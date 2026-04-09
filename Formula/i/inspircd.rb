class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/refs/tags/v4.10.0.tar.gz"
  sha256 "2db2fb8572437c8f333061cff47c9aea6cc2ba54ad2824b962940cf1b15cc49c"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "8717bbf510b34c120ecb46be55e7ea9fd23f5c24167ca6fc0ed2615d3cb1ef0d"
    sha256 arm64_sequoia: "7e05298c5eaf3076c42e568101b1e91a107d6c0d514c668ba18758b98d5781d4"
    sha256 arm64_sonoma:  "5b72ca2524c00523f1a2d796e8fd279238e5917a8d5cc40dcb43b0bffc9e36ba"
    sha256 sonoma:        "3fd464cf947c58714567667e5d961564ca657440f8dbce7c8a1492271f428cbf"
    sha256 arm64_linux:   "c568ed35a19ee3d085c3b34999f4f424f5572cde5cc5cdce735ca55e3cc2e0a1"
    sha256 x86_64_linux:  "f6ad2e398d39809bce2fd10fb4ba233ac703dd05ac376d2d8bb2abf1034d4f3e"
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
