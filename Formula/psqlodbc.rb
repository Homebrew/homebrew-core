class Psqlodbc < Formula
  desc "Official PostgreSQL ODBC driver"
  homepage "https://odbc.postgresql.org"
  url "https://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-09.06.0310.tar.gz"
  sha256 "6c42078af094d61baca2c8bd1dc4d137a77377198ef94e4eda5989bdce3474c3"

  bottle do
    cellar :any
    sha256 "8ddf0a7f5d06fe38c4a7429ecb3a22cf4b96b58d847e493410358cc0886b6fdd" => :sierra
    sha256 "5aeb648c9a73629c46551143f01230bef9781e8c337c06b879b187141bac5fd0" => :el_capitan
    sha256 "b8ba49f0d167189398492ad2961f4289bc964ffb5095c9469876daafb9235d5c" => :yosemite
  end

  head do
    url "https://git.postgresql.org/git/psqlodbc.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"
  depends_on :postgresql
  depends_on "unixodbc" => :recommended
  depends_on "libiodbc" => :optional

  def install
    if build.with?("libiodbc") && build.with?("unixodbc")
      odie "psqlodbc: --without-unixodbc must be specified when using --with-libiodbc"
    end

    args = %W[
      --prefix=#{prefix}
    ]

    args << "--with-iodbc=#{Formula["libiodbc"].opt_prefix}" if build.with?("libiodbc")
    args << "--with-unixodbc=#{Formula["unixodbc"].opt_prefix}" if build.with?("unixodbc")

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].bin}/dltest #{lib}/psqlodbcw.so")
    assert_equal "SUCCESS: Loaded #{lib}/psqlodbcw.so\n", output
  end
end
