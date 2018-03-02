class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/10/static/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v10.3/postgresql-10.3.tar.gz"
  sha256 "87584285af8c5fd6e599b4d9789f455f8cd55759ed81a9e575ebaebc7a03e796"

  bottle do
    sha256 "1d1e8080d5c3e3320accd163e5449b49bf1784080bb76101fe601195a113d6c3" => :high_sierra
    sha256 "0c87fa3da6997982d0d4036312d54bb5842b0352bf546efcccd9ffee5e7dccc4" => :sierra
    sha256 "ebf1f8ea52321098d3a7a465f7a8a62232c8759bedd48f0f25d1c56236e68cab" => :el_capitan
  end

  keg_only "conflicts with postgres formula"

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-openssl"
    system "make"
    system "make", "-C", "src/bin", "install"
    system "make", "-C", "src/include", "install"
    system "make", "-C", "src/interfaces", "install"
    system "make", "-C", "doc", "install"
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
