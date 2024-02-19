class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/refs/tags/v3.17.0.tar.gz"
  sha256 "181de90130e11a26ec107fcb6b74005cbce3051b89b500347e416054e29c3166"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f909dabd1cda182a8bffac9702d1ba9e6811cc184680c1723405c8e9c8d758ba"
    sha256 arm64_ventura:  "1300bfd953404cc3728e3fa6e6411350bdb395ff7361dbc50e1dc3ec1fa59371"
    sha256 arm64_monterey: "8f86230f1506baf2082fc140675d23f337303d71ce64c025ba8c6e304ce5b6d7"
    sha256 sonoma:         "ae5c22ec9be553b0a59ad856be6a56c6091673318eef9f4bb07cfba10a4ae4bb"
    sha256 ventura:        "ce39749fdb7a7e2a00c50009b35fdb83500676ff28634edc49d8192f11d86ce4"
    sha256 monterey:       "b97474dd548b126d240fd87708cf749cd06e1d9ee6e155ce79b722c8a77b14fa"
    sha256 x86_64_linux:   "335aeeb4df8b203befe37e35b80776f9679bcc36f263975a952fc2a24502ac8d"
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
