class LibpqAT16 < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/16/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v16.9/postgresql-16.9.tar.bz2"
  sha256 "07c00fb824df0a0c295f249f44691b86e3266753b380c96f633c3311e10bd005"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(16(?:\.\d+)+)/?["' >]}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_sequoia: "67a3882334f2448796238f87a74a594218dbf8cf19ab4161d7de7b0ca6146415"
    sha256 arm64_sonoma:  "25b4ea9f563b4d7098da7aec89f0891af7f4c60bd2fec6cc914b6791266c882d"
    sha256 arm64_ventura: "af1e4227b8408aa7d62ecce5681d739ca5e967e244ea47638c92cfd2c4fb4320"
    sha256 sonoma:        "234174030c3d3b291162f43c23b12515e0b16ce559b863c9933f7fd906c1cc11"
    sha256 ventura:       "ff78291761e454338f6f567915cd3e491f7775c92e8b4f7c9ca0577038d0f73f"
    sha256 x86_64_linux:  "c2dc9c741adb74eb78080bbd99630fccb056a3eb8e19220ba732b7a9829c8a46"
  end

  keg_only :versioned_formula

  # https://endoflife.date/postgresql
  deprecate! date: "2028-11-09", because: :unmaintained, replacement_formula: "libpq"

  depends_on "pkgconf" => :build
  depends_on "icu4c@77"
  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"
  depends_on "openssl@3"

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
