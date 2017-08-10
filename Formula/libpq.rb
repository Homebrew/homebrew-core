class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/9.6/static/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v9.6.4/postgresql-9.6.4.tar.bz2"
  sha256 "2b3ab16d82e21cead54c08b95ce3ac480696944a68603b6c11b3205b7376ce13"

  bottle do
    sha256 "1c17bcf26b4972c360009e475f7a89e1afaa68273cfc4c5b2dcfbb8f250e7530" => :sierra
    sha256 "f2454528f63410d062377f0681cf0c8b689a4f6fb6f91ed02d5ab50ccb75f4be" => :el_capitan
    sha256 "025d7862d9dc3acc56b33afaf27a77c05854400fa9201a34fa60d5717474413a" => :yosemite
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
