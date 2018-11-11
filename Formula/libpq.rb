class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/11/static/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v11.1/postgresql-11.1.tar.bz2"
  sha256 "90815e812874831e9a4bf6e1136bf73bc2c5a0464ef142e2dfea40cda206db08"

  bottle do
    sha256 "5afb0e937bf519808dffe071d58222e5fe7f36e93baa14b7bc7728078ca65845" => :mojave
    sha256 "9c530ec6a94fcd63447daed913e38cd58027655d8a97511391e882f2b39cdc1f" => :high_sierra
    sha256 "fcbc42add99ff7fe2f9ed9dfe2df3fd59a097fde7ee1ee41175734a3a23be294" => :sierra
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
