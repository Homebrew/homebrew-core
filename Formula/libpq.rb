class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/11/static/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v11.0/postgresql-11.0.tar.bz2"
  sha256 "bf9bba03d0c3902c188af12e454b35343c4a9bf9e377ec2fe50132efb44ef36b"

  bottle do
    sha256 "180a9196317b1a6d103eafd512f251726cf4930a2e0a185886990da0a8cba1b4" => :mojave
    sha256 "b56d3eccf119869633d92fcf97fb1a011fb799300f5ee9c138ee6e551930f7fa" => :high_sierra
    sha256 "e318de159854fef446fe77ec40eeb474c7b7e1970dfc285ae04156ddebac7ca8" => :sierra
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
