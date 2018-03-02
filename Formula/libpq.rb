class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/10/static/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v10.3/postgresql-10.3.tar.gz"
  sha256 "87584285af8c5fd6e599b4d9789f455f8cd55759ed81a9e575ebaebc7a03e796"

  bottle do
    sha256 "4de024a655a54d2d5da76d4b5fad3292e096eb150cf196cc98b364a15d50807c" => :high_sierra
    sha256 "c0df149b61305834c6622619b3ce262810cc357b3f7dd862d365e4111d3aa11b" => :sierra
    sha256 "9157b1c9b50f00ddbf6102c97bf8bdac6e939fd51a29919415b7a44d3fb2bece" => :el_capitan
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
