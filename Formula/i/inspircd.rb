class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "fcad041a46f1d7c635ba2ed41d7bcef1cfa2510a5692ac98b34f90420187c97b"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "25726c3cd16e4152b60e5954728b860301ef05097c030994075c26f1e87bba5c"
    sha256 arm64_sonoma:  "736a32bb3d0a02e08aeed2354a2f124ac9f9ad501d6c0b17a98f876e5ada3103"
    sha256 arm64_ventura: "0c20a2bbf5b9267494511cf817f9df92018f81b1dd31bada11cc62da1d854963"
    sha256 sonoma:        "acaac9dcbb9b05fb6b5634a3e00a0135d161c3277761377df0b8c6eaedb4d5b9"
    sha256 ventura:       "5cb7ec5be5faac2a8cbce377e82c4080a0b5dd73b60cb454ed4798994640286c"
    sha256 arm64_linux:   "38b1ffba9b147bb7cc7825460cf6c6ca2105c543471288637d9047598917f5ba"
    sha256 x86_64_linux:  "1b6aa72c698ca20cc3d757e0760a4e44b0bbdb113790e0ced655c646204542cc"
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
