class LibpqAT16 < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/16/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v16.11/postgresql-16.11.tar.bz2"
  sha256 "6deb08c23d03d77d8f8bd1c14049eeef64aef8968fd8891df2dfc0b42f178eac"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(16(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "5aba61107b2e0fb68e3b27d1ff01d71043dfd6a597c23fc3805ad9bcb6bada3b"
    sha256 arm64_sequoia: "45e814b4d5b2b76f96a5f94f58f469c12f261141460d3fc9c9978940f352095a"
    sha256 arm64_sonoma:  "e9748dc587ad502c3dff5cd860d14be0d1a5346c4998a6f618b5674a08f419a5"
    sha256 sonoma:        "7d93e0d135f047984a534d634ad633460cdd8e18a1a66f671b4c1ada9c5819dc"
    sha256 arm64_linux:   "39feabcf1d8eebcf611dedd660e532803c1576e0800c562cfe5a862942c596ed"
    sha256 x86_64_linux:  "31a15ff8ec678916af70ccf060435935e746d9d28a208654b5268817cf6e9fc1"
  end

  keg_only :versioned_formula

  # https://endoflife.date/postgresql
  deprecate! date: "2028-11-09", because: :unmaintained, replacement_formula: "libpq"

  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "readline"
  end

  def install
    ENV.runtime_cpu_detection

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
    (testpath/"libpq.c").write <<~C
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
    C
    system ENV.cc, "libpq.c", "-L#{lib}", "-I#{include}", "-lpq", "-o", "libpqtest"
    assert_equal "Connection to database attempted and failed", shell_output("./libpqtest")
  end
end
