class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/14/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v15.0/postgresql-15.0.tar.bz2"
  sha256 "72ec74f4a7c16e684f43ea42e215497fcd4c55d028a68fb72e99e61ff40da4d6"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_monterey: "aa77e222c22fac285b3d2803e016f2e639783091a7c68e8c6e64910fa4202251"
    sha256 arm64_big_sur:  "6c47b98f98488595c949ed1cdc8fa13c7700a3fbb6a9a6caf94ffa7f99af3d59"
    sha256 monterey:       "6542578222d27d56f66f5bfa78becfa24d80489c2f15f5956b00c9c670de1c91"
    sha256 big_sur:        "f12ce8546f540d4db9459a0f8a3e71e2a716549ba22e9a2c742905e6a865b278"
    sha256 catalina:       "a556a6b621986383e18402b7a628c1103766c886705d8caead4fe91f3044b5e8"
    sha256 x86_64_linux:   "0c4042f537667f7de09043db98d9e125b1921b6d815c5ded228aa5710b195fcd"
  end

  keg_only "conflicts with postgres formula"

  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"

  depends_on "openssl@1.1"

  uses_from_macos "zlib"

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
