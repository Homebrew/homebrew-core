class LibpqAT17 < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/17/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v17.11/postgresql-17.11.tar.bz2"
  sha256 "dd27f2b3c59e73ed14aa3324901242bf69a032a6347805f274e6260322d42979"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(17(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "e342d29121630a57594c6b6558b0a89c7a876bbe0383eacabf37e315a6f73bbe"
    sha256 arm64_sequoia: "a696294b642a915f9984ac665e505d3d02f2ce53966fe570b1d368f2f1f999ab"
    sha256 arm64_sonoma:  "51551c55754ba21caf3581ec638828b1e56c8877c93fde0814b748c6e96885a4"
    sha256 sonoma:        "747ca424b593148dc56c4ff285413008cf39830adb7bb372fdc56b6ac0483f8b"
    sha256 arm64_linux:   "78e8c6340155af19828b396fd7b14cacf16cb3a6d372851dc87466e9aeb7cc1e"
    sha256 x86_64_linux:  "3b5afdf705d1b233398d35f77c4aaa8b29d1672d56e7f5063ea9b7c3d51c7384"
  end

  keg_only :versioned_formula

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build # for xsltproc

  on_linux do
    depends_on "readline"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
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
