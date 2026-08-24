class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/current/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v18.6/postgresql-18.6.tar.bz2"
  sha256 "555610c24d53e4316da5b7d3fc25c279d96856d5e0e23ee308c328c5fa881d9f"
  license "PostgreSQL"
  compatibility_version 1

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "6fadf0b2e2ba3f6008086e624cb2417823988e78bccbe07b93a5f3cefc7573c1"
    sha256 arm64_sequoia: "f660d66a19e3960f16426f34b0350a84946672c23ce375408ff1d501e1a6d090"
    sha256 arm64_sonoma:  "00c6d6128a75ac52740c79f65af01961fd2c0408a3ce0797b7c185408a079c59"
    sha256 sonoma:        "509cb83e2fb3075e51c44d83a6db67d4f3dc1487a2996b101d4eeb304617b013"
    sha256 arm64_linux:   "ee5ac4a2e3c39f7756c2781f049068a155f5d6af3e74c56d6e4c05c034bc51e3"
    sha256 x86_64_linux:  "e4d1403cdb9c4f2c23551036ffc87f0ee3b5bc86df130caffcab9ed9cf6467e7"
  end

  keg_only "it conflicts with PostgreSQL"

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.runtime_cpu_detection
    ENV.prepend "CPPFLAGS", "-I#{formula_opt_include("readline")}"
    ENV.prepend "LDFLAGS", "-L#{formula_opt_lib("readline")}"

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-gssapi",
                          "--with-libcurl",
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
    assert_match "libreadline", shell_output("otool -L #{bin}/psql") if OS.mac?
  end
end
