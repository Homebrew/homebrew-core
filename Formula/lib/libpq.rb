class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/current/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v16.0/postgresql-16.0.tar.bz2"
  sha256 "df9e823eb22330444e1d48e52cc65135a652a6fdb3ce325e3f08549339f51b99"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sonoma:   "a1b3317ad90188aeecfba22df993ef3b03952a2ac848886f9c9d7c10273ce957"
    sha256 arm64_ventura:  "83bd2fc0f930e55833eb20c01ee8ac76691040a88d3fb2c75bc47884208714a0"
    sha256 arm64_monterey: "b4f695eb4aa4c15c2ff6384f65ff08a11b28ce95c378b2c3f18f21e3daf2b6a7"
    sha256 arm64_big_sur:  "591d0797f094ba77df24119f444654c3b7aae8d71704c4d0955deb6f372a7966"
    sha256 sonoma:         "77b16644b1dd3137441b9bb89c54bf5430d39fd3cb0de1a36c680e32f113620d"
    sha256 ventura:        "4e7cd93cdc7f17a9ac7ef0fa23fd0489fae91bc69f8c6a9fe469cc2b413d3f70"
    sha256 monterey:       "5cdf6c833744fc3734dcf9522cd35f7621ed495c464e2149dc152f02f55695bb"
    sha256 big_sur:        "6dcd42ae451b43e9b535b53c3a106d5ea9ae9f100ecef8e32172eb1b5bb827be"
    sha256 x86_64_linux:   "b36679d5711b99eb55da99653292206d8c0b8c2353b1aeec80503c827cd9a154"
  end

  keg_only "conflicts with postgres formula"

  depends_on "pkg-config" => :build
  depends_on "icu4c"
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
