class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-13.02.0000.tar.gz"
  sha256 "b39b7e5c41fd6475c551112fa724bf57c4a446175ec4188a90e2844cc1612585"
  revision 1

  livecheck do
    url "https://ftp.postgresql.org/pub/odbc/versions/src/"
    regex(/href=.*?psqlodbc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5389ada28349a7fc6e2c266936ffb55aa8df0a0329f4ee089b2cc016d9733adb"
    sha256 cellar: :any,                 arm64_monterey: "7dd883dc59524fede6ffb7b688bcc0326de3d3a427803351aa6cbabb599f9954"
    sha256 cellar: :any,                 arm64_big_sur:  "ef418d0c0adec1d244558dca6a0c9b40b9422885dfe10913b043f8b390ffef78"
    sha256 cellar: :any,                 ventura:        "a7d6387329a2c6e6affc126492f99a189506d41dc4de6676c25debd2e475c7c8"
    sha256 cellar: :any,                 monterey:       "36cc02c09e0c5a11ff94dec512b68cdd79eff6efd4c172eeb4cfb9a5efa06460"
    sha256 cellar: :any,                 big_sur:        "6b0e7ea093735cfa54ce55031b3fc3ead89f69d62fd45e4da15889d4b560f321"
    sha256 cellar: :any,                 catalina:       "eacd7323b46bf02bb9774e75a705e08a8847903c5627c98e84ed6f6b69dddbe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73ab22c2d6963e7b60ab6213c0858167c47a9d519397c2398f379d4595c9ac6e"
  end

  head do
    url "https://git.postgresql.org/git/psqlodbc.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libpq"
  depends_on "openssl@1.1"
  depends_on "unixodbc"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--with-unixodbc=#{Formula["unixodbc"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].bin}/dltest #{lib}/psqlodbcw.so")
    assert_equal "SUCCESS: Loaded #{lib}/psqlodbcw.so\n", output
  end
end
