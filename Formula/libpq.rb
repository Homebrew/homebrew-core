class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/14/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v15.1/postgresql-15.1.tar.bz2"
  sha256 "64fdf23d734afad0dfe4077daca96ac51dcd697e68ae2d3d4ca6c45cb14e21ae"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_ventura:  "11c790baa5278d46dbb8b7d608f8b6923b15ea088316cce195a5884e80722fe6"
    sha256 arm64_monterey: "93be59131fe599125fbab83e21a0f954d866957a8fd139f8e822b21d5300befe"
    sha256 arm64_big_sur:  "a5511600bb6cbaa3a3390e28a71af479a5b8029acf1f983dd4d13a689adb7061"
    sha256 ventura:        "ade5f847fb8983c90925de5af9b6b31fff56a7bd1f7df48f6163aeb8915a0f1f"
    sha256 monterey:       "604c9dd5993ae0714368de1a0650fe64a080344036e0cad01dcdde4f2269ffda"
    sha256 big_sur:        "e00d7a4108c1711fde8e7cf8135ccfff3a6be35c4164ae5e9c9ffd24bd7affa2"
    sha256 catalina:       "4bbee3b57e052af467ed9cfd57980a029949ff1aa34fed453109bf7fac60fc1f"
    sha256 x86_64_linux:   "873dc20eecf1bf1263bd0ccf00762cd5869459dd4b320faf7ba97441c0a35d8a"
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
