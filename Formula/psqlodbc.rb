class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-15.00.0000.tar.gz"
  sha256 "ca57d6349532ea7fb4fae17bbfc107abe5a155ca2f43446315f9e23764b3f8ec"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://ftp.postgresql.org/pub/odbc/versions/src/"
    regex(/href=.*?psqlodbc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5f595366d9c5363a64dca8bcc40216cd632d3925f1b5801036e1481e7ac73e1c"
    sha256 cellar: :any,                 arm64_monterey: "0a113c5ed10c2ee4747cf518f945195cfd5e59a89ce6cdd4839da32b3d8a9adb"
    sha256 cellar: :any,                 arm64_big_sur:  "a6c66641f0eb54e75e790179b8aab1e797b7d8351412887a0e77283fdaa9ce61"
    sha256 cellar: :any,                 ventura:        "696c4b6853fd46943ea5a04dd7c91d32b56d95f123a5926673658993caea650a"
    sha256 cellar: :any,                 monterey:       "9d9af226be6ae8f4a9596160212b9fb8f1d7d04979f429f312c81296be33df9b"
    sha256 cellar: :any,                 big_sur:        "c83334532fea91ac0368d94166d2ba75c917fe9baa8b1634bb3c37a4172f4165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "434eea38f0c573b6d7484f97ada13e4afae922d837bbd2d12aab4c2d396c6aaf"
  end

  head do
    url "https://git.postgresql.org/git/psqlodbc.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libpq"
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
