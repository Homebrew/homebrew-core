class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/current/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v18.3/postgresql-18.3.tar.bz2"
  sha256 "d95663fbbf3a80f81a9d98d895266bdcb74ba274bcc04ef6d76630a72dee016f"
  license "PostgreSQL"
  revision 1
  compatibility_version 1

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "83c92657e3f489a75abd4bdaed670e820c7233b8debed7d3ff7074114fb9d085"
    sha256 arm64_sequoia: "c82cc80b71bc999f6d1ff7320ee7fde9b21f551aa7f8ffcfe108d44f06beaec8"
    sha256 arm64_sonoma:  "30d29282b4ad5c723246a17f4c6fe5c350f50db3f65e877a005958464a440328"
    sha256 sonoma:        "df3adabfb494391f9b65d12d99fee9400cf0858f78cd6328f34c2a630cca0e74"
    sha256 arm64_linux:   "3848004e1178a889ba93ed3e9bafd93c291804c18de943938e8affbc3d1a10b3"
    sha256 x86_64_linux:  "e398965f0acb69751fc6c81b9357a73c23d36d32f324153ab5312ed0ba1d67b3"
  end

  keg_only "it conflicts with PostgreSQL"

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@78"
  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"
  depends_on "openssl@4"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "curl"

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
  end
end
