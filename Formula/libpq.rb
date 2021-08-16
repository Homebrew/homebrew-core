class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/13/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v13.4/postgresql-13.4.tar.bz2"
  sha256 "ea93e10390245f1ce461a54eb5f99a48d8cabd3a08ce4d652ec2169a357bc0cd"
  license "PostgreSQL"

  livecheck do
    formula "postgresql"
  end

  bottle do
    sha256 arm64_big_sur: "07bbbed8467ac5d351bed8a3013f5d024c70dd09036f7fa82b5492f0cd9268cd"
    sha256 big_sur:       "7a5b1acd39e13179dac2d14b6ea864ab1dbd064e43e6190377f1807f82553c96"
    sha256 catalina:      "7400649f006c9bfba58325af1b2730f73082f151f86cfd23bb712b937c2d9885"
    sha256 mojave:        "2fa59186a567d6fe9a3e361327503698b7c165921fb94a8b7c01ba5dc0e56a26"
    sha256 x86_64_linux:  "f968088d68b559df62501bf13fceb58239a6552f749e43e9750a96c2bbed1319"
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
