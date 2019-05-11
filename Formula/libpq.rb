class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/11/static/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v11.3/postgresql-11.3.tar.bz2"
  sha256 "2a85e082fc225944821dfd23990e32dfcd2284c19060864b0ad4ca537d30522d"

  bottle do
    sha256 "464e74593da2d7b8c9375d74346e7d6216c61d0d37359e78d2fc354e3e84e4d0" => :mojave
    sha256 "ba645036b965e3e777d3c2c3b73078e67e40d4a215db26caff3e27536c7381a3" => :high_sierra
    sha256 "825b052e67e74725c99a7539fbcfccd0111d7f288e67559f0a5c634e9d83704e" => :sierra
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
