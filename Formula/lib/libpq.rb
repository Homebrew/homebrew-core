class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/current/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v17.4/postgresql-17.4.tar.bz2"
  sha256 "c4605b73fea11963406699f949b966e5d173a7ee0ccaef8938dec0ca8a995fe7"
  license "PostgreSQL"
  revision 1

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sequoia: "d8ade9cb5deef5a893d1358e0501444d7d14a7dd216d1722b55cf8e1dbe765e3"
    sha256 arm64_sonoma:  "edbf11d3ab9246ef639cbb56106e39dc696f49d6dc7be22075af3c60575888f9"
    sha256 arm64_ventura: "e99ecda84fb5f0916f880c9c948f09b39c9d41e8753fd1fbc8bba6df69fac2ea"
    sha256 sonoma:        "56e9a1b6989876211ac979f936f54aed74af06371f039b331f15c970d9924ec7"
    sha256 ventura:       "020d0f1ad534770b2341a0bc0c836377a5e741fa1aa288a2c700e980d1f9ced1"
    sha256 arm64_linux:   "b53f6a940943be15290dac3a7efe1985c4595e78263a2c81622dc74ebe232715"
    sha256 x86_64_linux:  "85f0b26d9fca6e6edb0683ce4a39279cdbce9c447bcd278041c1bac9e8ef5af8"
  end

  keg_only "conflicts with postgres formula"

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
