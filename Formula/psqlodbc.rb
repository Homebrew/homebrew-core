class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-13.02.0000.tar.gz"
  sha256 "b39b7e5c41fd6475c551112fa724bf57c4a446175ec4188a90e2844cc1612585"

  livecheck do
    url "https://ftp.postgresql.org/pub/odbc/versions/src/"
    regex(/href=.*?psqlodbc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ed1b6837baffae5f6c56b867601f01a2e3afe17706a0807181f313bb433689d5"
    sha256 cellar: :any,                 arm64_big_sur:  "45bf96f7600543acf57ff529ac884ce9da5d84ab3df2fba8c799c318988b17a8"
    sha256 cellar: :any,                 monterey:       "9acc450ccbb8c63aebbc866a17f2b71b75297740ac8f6c9ea6bab5883f74e4a6"
    sha256 cellar: :any,                 big_sur:        "8109e135efa71d1e0369b2433181819ef275bec48934a5b3107f99fcdce73efb"
    sha256 cellar: :any,                 catalina:       "6da4ec9d0ec4ce763dc117b4e8c465289a90ea05c5c4d8bc954789334ea8021c"
    sha256 cellar: :any,                 mojave:         "c766f5701dba28974ac654fcba040715fcef30a6fc9974802d7b61a5d63e0584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de683e7933da22982cc7d6804a8d5ebb0333c87c8cff49aa3ec23c8e2119ea8b"
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
