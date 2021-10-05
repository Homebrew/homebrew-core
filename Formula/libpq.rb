class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/14/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v14.0/postgresql-14.0.tar.bz2"
  sha256 "ee2ad79126a7375e9102c4db77c4acae6ae6ffe3e082403b88826d96d927a122"
  license "PostgreSQL"

  livecheck do
    formula "postgresql"
  end

  bottle do
    sha256 arm64_big_sur: "c36e78fce303f7320e9d9b972c013ba83511cbfb03eaa344d95c4f76e7642f32"
    sha256 big_sur:       "a175edce0a65ff0c6b64136bd88271537c946c221f9a6ea41ea41c8191822def"
    sha256 catalina:      "c1145e71066f8dff4a4f9217d7fc4a8efe3681017fe79a5952e36485c46fd51c"
    sha256 mojave:        "93b500656d50444c081fc70b0709a38203c621b13713074e2ea866c7f117d172"
    sha256 x86_64_linux:  "b9ccefe07fd25caa5f04609b6a82765a00f874a65f526ff8308da7e688822f13"
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
