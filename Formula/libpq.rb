class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/14/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v14.2/postgresql-14.2.tar.bz2"
  sha256 "2cf78b2e468912f8101d695db5340cf313c2e9f68a612fb71427524e8c9a977a"
  license "PostgreSQL"

  livecheck do
    formula "postgresql"
  end

  bottle do
    sha256 arm64_monterey: "36b074f07ded99c1945dbcc26f54e45abeba0dbf34d16e63fb6ab16d371158ee"
    sha256 arm64_big_sur:  "a3fff4783cf1f60544db79e6476a3adb6b6d3398a558e6be62c4cb9f07977725"
    sha256 monterey:       "9f7a628d2ca6f3ef1613b1ca4f754cb270e18a28ca5f7bed30001f4a51fdd9f2"
    sha256 big_sur:        "a85a1932a49c8cbba9cf90f9d1f1af30190a8effabda965ce2a4b9a618a26fd3"
    sha256 catalina:       "b4263f4a513e3e97f0735de8d5919af8a1aa574101e8fcb9db414f1cc2173583"
    sha256 x86_64_linux:   "2e935bd76326ff8254db26eb04256a672e75604b1ddcf8505ad3a6aee6f8d5ec"
  end

  keg_only "conflicts with postgres formula"

  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"

  depends_on "openssl@1.1"

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
