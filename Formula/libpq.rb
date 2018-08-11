class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/10/static/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v10.5/postgresql-10.5.tar.bz2"
  sha256 "6c8e616c91a45142b85c0aeb1f29ebba4a361309e86469e0fb4617b6a73c4011"

  bottle do
    sha256 "86701653028d7cdde8a18e4f11cbca42015cf004c0f7a1eac6fbf0ab1e928178" => :high_sierra
    sha256 "fd2d8807b4825523bafd26b5cb89dfc534632535fae310fb749f4c5528c5ddce" => :sierra
    sha256 "14f520810ec641b992b5f65894a3944942c17d72ece4b670274debc40f3dcc58" => :el_capitan
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
