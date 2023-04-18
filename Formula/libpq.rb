class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/15/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v15.2/postgresql-15.2.tar.bz2"
  sha256 "99a2171fc3d6b5b5f56b757a7a3cb85d509a38e4273805def23941ed2b8468c7"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_ventura:  "c070425023520a337b84ace4ab2735577b00055bc7e4870c6993b6e6ca93a750"
    sha256 arm64_monterey: "15e14f40369631580b69778d0a9c92b951f3e969ae40cae9c0b5fadbd8509a26"
    sha256 arm64_big_sur:  "f58a19b8834600e6b42595f40c1295dc25d8246c695a798df99b55b189709472"
    sha256 ventura:        "1c588ee96000d09510522991025d15d49ed34b004eb6d4b6b2ad17dbae5956cc"
    sha256 monterey:       "ca68207e33c0ff6a394a85d2ed7fa0c07aa4fe6f80e21acd321e7ffbe2f214bb"
    sha256 big_sur:        "66552a11b4f11fc93128ff292487d3c4508ae7d06c909db74131f619b16e9fbe"
    sha256 x86_64_linux:   "d13f0d4a667199a5427cba37a5af212ca9676daed78054c1730f0b75426679ee"
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
