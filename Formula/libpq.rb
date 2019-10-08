class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/11/static/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v11.5/postgresql-11.5.tar.bz2"
  sha256 "7fdf23060bfc715144cbf2696cf05b0fa284ad3eb21f0c378591c6bca99ad180"
  revision 1

  bottle do
    sha256 "40e1dae7e45682dea663096349858936ce6b885ce25db523f27469e3f18febab" => :catalina
    sha256 "641895e3f770b0eaa23bb7669c6ab8a198d67d341237cd1da6751f3e22ed8549" => :mojave
    sha256 "f95a9ac7f46a6a1ad8c74e609c0ab2160591457ff8aa8785ea08792d90d4efb6" => :high_sierra
    sha256 "94894610fed9516c72b9ed8bade18869d6ff71cd6ab2a28db2ed604ace0a023e" => :sierra
  end

  keg_only "conflicts with postgres formula"

  depends_on "openssl@1.1"

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
