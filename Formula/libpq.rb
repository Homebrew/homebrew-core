class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/14/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v14.4/postgresql-14.4.tar.bz2"
  sha256 "c23b6237c5231c791511bdc79098617d6852e9e3bdf360efd8b5d15a1a3d8f6a"
  license "PostgreSQL"

  livecheck do
    formula "postgresql"
  end

  bottle do
    sha256 arm64_monterey: "61472d266573d7c2b9f4f0486c308893162ce8e523c448ac8bb7fe02d17b6eef"
    sha256 arm64_big_sur:  "2a2c3a32356dd1e36b43d529efa41d62ab95889e86cf584efb739a067b0c0b31"
    sha256 monterey:       "21f60743dabe663a0897836462530221707a56e21b18fb7f83d0634da6ecfcde"
    sha256 big_sur:        "5347200def4077d9cf7580835dc17b01329aa0f8c93fa658c32a43d79680abdb"
    sha256 catalina:       "be31c70ff23af4cdf06d475a43072a885a4f8a166620b19dfb6235657e248db5"
    sha256 x86_64_linux:   "cd6846a68309bdbeff13827d150aa0ced3956bac55bde21fa5015a5ff0b9b026"
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
