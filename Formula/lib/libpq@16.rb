class LibpqAT16 < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/16/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v16.12/postgresql-16.12.tar.bz2"
  sha256 "b253ee949303ef5df00e24002600da4fb37e5ccfafa78718c6ea6a936b4d97f1"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(16(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "f6f6ab2c5b292cad4dc3ca7e419cf06f8810dd818609a0ff568418705a53c4c9"
    sha256 arm64_sequoia: "31f6ec19bdf6fda6d559ab5aa06f6f3841a282f0c6bfd00e9aea2cabc6fd7e46"
    sha256 arm64_sonoma:  "5ace23b0bb53502bccb9808e854409ebb444c89fb033b24319378a2d879c3294"
    sha256 sonoma:        "d63b6ad4cfd68672e7ad6bc8e3227820ad2072694a1578b992743b5c2d2a516c"
    sha256 arm64_linux:   "4bc5e5364c2aa1ed10bd126f32961a667daebbef8a45f3aeef410cd7a524d36e"
    sha256 x86_64_linux:  "5ef819a331cd170cff84a07714c7a16de135879a26c400fde1e1e97dee749c71"
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

  on_linux do
    depends_on "readline"
    depends_on "zlib-ng-compat"
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
