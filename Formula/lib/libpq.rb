class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/current/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v18.0/postgresql-18.0.tar.bz2"
  sha256 "0d5b903b1e5fe361bca7aa9507519933773eb34266b1357c4e7780fdee6d6078"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "c18bfa80a4e1d0dc070110db4d049c2c8ade1e6e99d63137f75f6a71c588eacf"
    sha256 arm64_sequoia: "3d598f9d52ab87201a766bb9e2f2994936a648715835fd117ebdcd4053657a51"
    sha256 arm64_sonoma:  "c461783362ef84350fefa58ba6125b75def2be4fe3d280e6352c47d5d3853c3c"
    sha256 sonoma:        "7a11639f02dace4fc119a01cb6289e8135a274acb3eb50aedc038056a54bc578"
    sha256 arm64_linux:   "04f59478f4bb3fe1f2c0e3645915cd5871ecf8e9293bb8e7776c0dac7f2061b7"
    sha256 x86_64_linux:  "f40cc688f06fb820de47f84243a51d654227dc82d154a2f43b5905eb114b7f73"
  end

  keg_only "it conflicts with PostgreSQL"

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@77"
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
