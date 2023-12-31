class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/refs/tags/v3.17.0.tar.gz"
  sha256 "181de90130e11a26ec107fcb6b74005cbce3051b89b500347e416054e29c3166"
  license "GPL-2.0-only"

  livecheck do
    url "https://github.com/inspircd/inspircd.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "765ec9c1d774f6e55096e6341342b8e5b361c25a6931437ecaee293d659b60b9"
    sha256 arm64_ventura:  "f9bcdb65e4317b03bf88af82c2f6702ed40a645e189c13cd73f844825ed8f982"
    sha256 arm64_monterey: "b6e7232234ca5082e64ef39cf1bf89d7ff54d9f756eb37cde8b0275890a059f5"
    sha256 sonoma:         "522d9d2dcc7306151e3fc0d54b8dd65ebd602a5eb0f166feb397adc3d8678b25"
    sha256 ventura:        "1b5051200899dc7b8b52fc6f21d03b642a69b043f7f20d374e449dce46d29ea6"
    sha256 monterey:       "ea88c8c2914778202b8f2f3cdb18bd29b7a4c06dcafd958e2bc2af00a400c513"
    sha256 x86_64_linux:   "6e16e1cce59a398ed56dc26c73096748fb014c7c90f473c22b67e994e9462c0c"
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
