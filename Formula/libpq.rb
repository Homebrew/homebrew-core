class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/12/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v12.2/postgresql-12.2.tar.bz2"
  sha256 "ad1dcc4c4fc500786b745635a9e1eba950195ce20b8913f50345bb7d5369b5de"
  revision 1

  bottle do
    sha256 "64bab543c341a2e26246aa434c8ef27c48985f397996a975751f2c5ea91cd3c3" => :catalina
    sha256 "a5018ed3a4e60e321d1d5d10eb87616243e80c81673b4e59bbff294a24f5cef9" => :mojave
    sha256 "9ac9a6f2272f22ae16855337288b156b70ae327624cdf8ddfb73cabd78fe783f" => :high_sierra
  end

  keg_only "conflicts with postgres formula"

  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"

  depends_on "openssl@1.1"

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
