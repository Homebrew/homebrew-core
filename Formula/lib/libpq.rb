class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/current/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v17.2/postgresql-17.2.tar.bz2"
  sha256 "82ef27c0af3751695d7f64e2d963583005fbb6a0c3df63d0e4b42211d7021164"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sequoia: "19a546873543dc5f5f371e58189b78d271572c004439a91adee9197304fa0d58"
    sha256 arm64_sonoma:  "4c57a872e4e82a403b8d835f444d4ac2f75e9eacaa578bac328de028fc756bb4"
    sha256 arm64_ventura: "b9f0e38dab1a54c8bac3ec7379d37c23a9b499dfe8bb4fb19f47407f1a0fd743"
    sha256 sonoma:        "8c9f2f6cd6900fba195e644ac33064cca523fb09d8fa73215e13a519163cbeff"
    sha256 ventura:       "357e8a8078ca089792f32bc0993cb2db1019aa2a5a94771af7b9ee9e1290d4c6"
    sha256 x86_64_linux:  "4692a1ed22511d941e2ef0e09d4ac85771752461b48d3c7878af9046de828197"
  end

  keg_only "conflicts with postgres formula"

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@76"
  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "zlib"

  on_linux do
    depends_on "readline"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

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
