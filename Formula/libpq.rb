class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/9.6/static/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v9.6.3/postgresql-9.6.3.tar.bz2"
  sha256 "1645b3736901f6d854e695a937389e68ff2066ce0cde9d73919d6ab7c995b9c6"

  bottle do
    sha256 "fc7ee090e7864661f5f0d77a4d148ee2727ed48bb68ea1f6543ec2cbe60c7f71" => :sierra
    sha256 "43b9913b52fb7798ccece25a406e771f6dc544c72de173a33b8abf7e26f9b65a" => :el_capitan
    sha256 "4083597f56940a57df6a28ec1f27d428d8acca30dd61b284a6e53752acd82ca5" => :yosemite
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
