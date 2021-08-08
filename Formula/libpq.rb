class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/13/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v13.3/postgresql-13.3.tar.bz2"
  sha256 "3cd9454fa8c7a6255b6743b767700925ead1b9ab0d7a0f9dcb1151010f8eb4a1"
  license "PostgreSQL"

  livecheck do
    formula "postgresql"
  end

  bottle do
    sha256 arm64_big_sur: "81801a5428038a98059bc8679d1cc17c580f2c547219c7ff323aa140dfa71350"
    sha256 big_sur:       "151bc976994fc3373e6bfd47fcacd20b66724066148d6e6774e84608af2e8e51"
    sha256 catalina:      "a3674fbd50ef933e866f0e28e971c03812f07be661cc50d07a033981e76d87a3"
    sha256 mojave:        "e16bc609f7001cf004ac76600c58e6d6b4ca321ff106da06e52cf20e66357c5e"
    sha256 x86_64_linux:  "ddcf71d287da27b5d14ba05636a4b87def286f61ad6e4b0c4a54e7245e9daeee"
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
