class LibpqAT16 < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/16/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v16.14/postgresql-16.14.tar.bz2"
  sha256 "f6d077142737920858ce958ccdb75c6ee137a63b5b0853c70693d401ac7e3471"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(16(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "ff4944817a39511786c625ba5415ce4bbbe2ae483c4d648b39f8cffaba1d622c"
    sha256 arm64_sequoia: "b46ac41117c2cc68f2e6e877e4c64ecbe50dc263ed035d619ecd3fda739e430d"
    sha256 arm64_sonoma:  "b97df2c07bad416e7514d339c4c680bce88929e58a05cb8139a9be8b80d575f1"
    sha256 sonoma:        "a49e9f6086d867b249ee32582ffb1d704d1aacca7a2e069c491b5bc7a9f173f0"
    sha256 arm64_linux:   "ceb9e6017d56f8f15cf58e574bb4417a277b265a2994aca3094364326b68c16e"
    sha256 x86_64_linux:  "0baa7f8f0aa6b12f4cb38ae2d39e708cd2f7e2a6943716a683b5075f6cbe1277"
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
