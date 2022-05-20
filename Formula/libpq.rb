class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/14/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v14.3/postgresql-14.3.tar.bz2"
  sha256 "279057368bf59a919c05ada8f95c5e04abb43e74b9a2a69c3d46a20e07a9af38"
  license "PostgreSQL"

  livecheck do
    formula "postgresql"
  end

  bottle do
    sha256 arm64_monterey: "5290045c3abed1bae0a5bd9b17e49b330c042869f8f080eb5b08e7c4b7f458f6"
    sha256 arm64_big_sur:  "4868ef381deaadda4debd6d9cb92d0bcd6fbe49536b5fe7d012671d747b7bf65"
    sha256 monterey:       "114c88e4612f103a09c27fe5ac415913b7f171b2228e2fb5c6ba5449998f4fb2"
    sha256 big_sur:        "a01a73c5e923bdade92e29762b9066fd6aed8d8050ae0b491eda63b6486f9735"
    sha256 catalina:       "ddb99b2623859237f230532d8589a5355203ffe963a31a02b5d012c3d80cfea0"
    sha256 x86_64_linux:   "627bdf2ac98d68e5df48d0a1bc84e5d82012377fb3c9f33357d6f2d3870a0d5c"
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
