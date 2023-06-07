class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/15/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v15.3/postgresql-15.3.tar.bz2"
  sha256 "ffc7d4891f00ffbf5c3f4eab7fbbced8460b8c0ee63c5a5167133b9e6599d932"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_ventura:  "222625b518651724851680282b269f164366bc06220ee66ce4da9360f0df1443"
    sha256 arm64_monterey: "5456b75374097b6558eb2e7d7c2f0ed7a67418e93688d44d22aad92c2aa64102"
    sha256 arm64_big_sur:  "4bc7811549397cb67bac052753f468411942dba347136ae138ca4414333cef35"
    sha256 ventura:        "a0731fabb26973dc162f66f4a5741c1548416f7f9bf9e7d8a8eb7911d19af65a"
    sha256 monterey:       "b27eb40da814e12cd8dba2e768bc740afac91f354baee0017c93f373e26ca926"
    sha256 big_sur:        "21f6879e39fd4121da6902a11f2945dad8859611118190ff4d50848d75811ec2"
    sha256 x86_64_linux:   "3c09f46b21cc274155e26f406c6fdd82ac4d658f9b2781f00975e5a9988f0b5b"
  end

  keg_only "conflicts with postgres formula"

  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"

  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-gssapi",
                          "--with-openssl",
                          "--libdir=#{opt_lib}",
                          "--includedir=#{opt_include}"
    dirs = %W[
      libdir=#{lib}
      includedir=#{include}
      pkgincludedir=#{include}/postgresql
      includedir_server=#{include}/postgresql/server
      includedir_internal=#{include}/postgresql/internal
    ]
    system "make"
    system "make", "-C", "src/bin", "install", *dirs
    system "make", "-C", "src/include", "install", *dirs
    system "make", "-C", "src/interfaces", "install", *dirs
    system "make", "-C", "src/common", "install", *dirs
    system "make", "-C", "src/port", "install", *dirs
    system "make", "-C", "doc", "install", *dirs
  end

  test do
    (testpath/"libpq.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include <libpq-fe.h>

      int main()
      {
          const char *conninfo;
          PGconn     *conn;

          conninfo = "dbname = postgres";

          conn = PQconnectdb(conninfo);

          if (PQstatus(conn) != CONNECTION_OK) // This should always fail
          {
              printf("Connection to database attempted and failed");
              PQfinish(conn);
              exit(0);
          }

          return 0;
        }
    EOS
    system ENV.cc, "libpq.c", "-L#{lib}", "-I#{include}", "-lpq", "-o", "libpqtest"
    assert_equal "Connection to database attempted and failed", shell_output("./libpqtest")
  end
end
