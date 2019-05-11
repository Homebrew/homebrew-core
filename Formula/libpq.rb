class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/11/static/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v11.3/postgresql-11.3.tar.bz2"
  sha256 "2a85e082fc225944821dfd23990e32dfcd2284c19060864b0ad4ca537d30522d"

  bottle do
    sha256 "7683b433dcc0a91262c223e58b5881339d9c8d424642f5fa27ad4db565ad8f36" => :mojave
    sha256 "7748348f3edfaf8b3838d80374ab80f715dd7e0bbb45b4a75af5994ac2582d29" => :high_sierra
    sha256 "1abee44829b2d83b96c144d0c54bb0efe1d4f2d05bdb0236965a32df2c23c69f" => :sierra
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
