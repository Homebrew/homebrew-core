class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/12/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v13.0/postgresql-13.0.tar.bz2"
  sha256 "80e750be8d436b54197636a02636f8fd3263ba6779bf865b04832495ea592296"
  license "PostgreSQL"
  revision 1

  livecheck do
    url "https://ftp.postgresql.org/pub/source/?C=M&O=A"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 "114ddffa1e218ebd7b4c2137bae87428c2ab1bf9dfbfc31aa4211a3d245f15f8" => :catalina
    sha256 "bf353adff487204fd03f502c2015693ce1696e4cda1aa77a92151b0232385499" => :mojave
    sha256 "55561c9296619cd25c096155d00923a8719dc5af9a6e0fe00023124807df92e1" => :high_sierra
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
