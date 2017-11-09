class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/9.6/static/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v9.6.6/postgresql-9.6.6.tar.bz2"
  sha256 "399cdffcb872f785ba67e25d275463d74521566318cfef8fe219050d063c8154"

  bottle do
    sha256 "598b7bb7c7e69bbd781c8f521ffd71d212acfac3ceb68c5f6e3672d078ff3f22" => :high_sierra
    sha256 "8e1df6c6372d0f68bcfc463797205145205a6de4b5ffbb55edf761ba48b71986" => :sierra
    sha256 "e0aba71bfa8a6c8daa47649c1764f42f628b844b7594fa36d5fdd6313c442121" => :el_capitan
    sha256 "9dfaafa1b691a00bab92f677120d83b0909a454d6a44523a162821f5192e2cb2" => :yosemite
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
