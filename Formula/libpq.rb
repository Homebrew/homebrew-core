class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/9.6/static/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v9.6.7/postgresql-9.6.7.tar.bz2"
  sha256 "2ebe3df3c1d1eab78023bdc3ffa55a154aa84300416b075ef996598d78a624c6"

  bottle do
    sha256 "37358285ce2c5dd59ca16265f269da09d7087dfd6f6482b33125897fe9273f6f" => :high_sierra
    sha256 "8c72001545d64bf639ca7acdc59ab9f8c4a728f9dd79334754cd8503c6037254" => :sierra
    sha256 "551cd8667bebf16860333bb3f0f3887a59881d4319cf1ee5b7b2600ddb04dd9e" => :el_capitan
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
    (testpath/"libpq.c").write <<-EOS
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
