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
    sha256 cellar: :any, arm64_big_sur: "fc5b844285d44f184e3c8e15f6837dd72c8633f884903c467534d59aa82dadbe"
    sha256 cellar: :any, big_sur:       "dc00104df170c4a7d76b5a6ee00e721f8bdbff6b7d5d06c2002d60c883de5c75"
    sha256 cellar: :any, catalina:      "3a8dbc9d7c56020a5d775fb8275599cdcea33456546f371cdabf9822e0778669"
    sha256 cellar: :any, mojave:        "b2278560b6a308742d65a4b956736c6c597ceb8d94f757a7d178623b5711328b"
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
