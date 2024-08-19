class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "4b07359c5528489cd312a6e1bd27a6e5161f839c62699f4d3113cb3cb50250bb"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "c5c8f38c981536f79d27db389742ae2e9b2148899779ee5415bcd77db75f393f"
    sha256 arm64_ventura:  "d13bf8a49b469297c9e106984c1d17a87b452144f4b84af1385f19c9032aff18"
    sha256 arm64_monterey: "13cd90bd8c8e1e0788df123afca665ccf8a63ff89a3b6993cbe5753999b385ca"
    sha256 sonoma:         "e43e20260b535df236d185d9185d45fb98bfd3e2e7517278de3d95fc7ed66313"
    sha256 ventura:        "00efba30a1da75f9782132f8c93db0ce1ccfce1f2c5ea50c06aede04ed739a98"
    sha256 monterey:       "4aef9bc42dbcaed6e8ca1ecb7bc8da05ce0556c5fbc4f9e04df48659f8d40b10"
    sha256 x86_64_linux:   "f8a6aba2f020a8e1f6d65fb5e40b365b1e15a3d8ea5524b38385cb78d959d0d5"
  end

  depends_on "pkg-config" => :build
  depends_on "argon2"
  depends_on "gnutls"
  depends_on "libpq"
  depends_on "mysql-client"

  uses_from_macos "openldap"

  on_macos do
    depends_on "openssl@3"
    depends_on "zlib"
    depends_on "zstd"
  end

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
