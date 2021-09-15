class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-13.01.0000.tar.gz"
  sha256 "435de2ea38109b8384ed76d327032b73a53a915379a752a34b0f9c7539055da7"

  livecheck do
    url "https://ftp.postgresql.org/pub/odbc/versions/src/"
    regex(/href=.*?psqlodbc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "f8d95d1b2ba785dcb50b91b0b50e49b4f40d7f05b5417dc7eaf8b078ca88464a"
    sha256 cellar: :any,                 big_sur:       "4bc2ee5d89cc5f84220abdcbcef1a42b30959cf19b071a46a13cb9c583ee9142"
    sha256 cellar: :any,                 catalina:      "3d65ab705dbece7ef42f2fc975e3ee8f118a6fc1e12a51d9b34425cf83dfc860"
    sha256 cellar: :any,                 mojave:        "9b8332fa7f0b03677744c1e48057e65f04140892cc143fa32858179c9f1cc38a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4befb4353cbd839bebed19fd661449af4f0c31b61063dadaa32bb318aaef1a80"
  end

  head do
    url "https://git.postgresql.org/git/psqlodbc.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"
  depends_on "postgresql"
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
