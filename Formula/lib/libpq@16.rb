class LibpqAT16 < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/16/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v16.10/postgresql-16.10.tar.bz2"
  sha256 "de8485f4ce9c32e3ddfeef0b7c261eed1cecb54c9bcd170e437ff454cb292b42"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(16(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "1244f976862826cb4bdf009e65dca147c254db32b256afeb35686bd71c4a09eb"
    sha256 arm64_sequoia: "beb13e0a39d01228e8131f9374f2b081fb0ce411ddcc8067e5a2df9be8f6565c"
    sha256 arm64_sonoma:  "8bc485c39dd78ee9de37d9eb6e806169234bcd9d3ff935da968246f1c85f12e3"
    sha256 arm64_ventura: "dfcf349344f6873404e5dcb56517d576096807012cb6c70e4293e070718b923d"
    sha256 sonoma:        "7b91801b83d33f1da86c646b9416e7d085c546fbdd67c1abcb6e7fdb06926622"
    sha256 ventura:       "15cfcd112efbb751f357dcd59b351a5ac7928ffe018867223f03a80be63c02bd"
    sha256 x86_64_linux:  "71f6f37401e382d06055f4c0b9edd82c604c938cb75f217ef962d98a1b8d33ff"
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
