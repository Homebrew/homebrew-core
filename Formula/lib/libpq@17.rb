class LibpqAT17 < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/17/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v17.10/postgresql-17.10.tar.bz2"
  sha256 "078a03516dcdbdb705fecaf415ea3d13a956c589e46f09fed68a06fb00598c90"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(17(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "34a72d507e39d0b1fc5e59ebed950f552848b10b9ffebbe2e2a4932a6b3c14eb"
    sha256 arm64_sequoia: "a27d32c2be85a17c6b34c2eb0b3d2ab33d30aef0b7758c289c66e3d4c23f1ed7"
    sha256 arm64_sonoma:  "1d0070a1f31b1dc2ee78aff894cbeb316891fe17a416605d5a663cd4b62dc4e5"
    sha256 sonoma:        "d03fcda60d1a9e6cd6b053b21b5bec6570c240cffdd9073aec806b2ef056ff01"
    sha256 arm64_linux:   "4d4c14d757f6d6d17fb42e8000285fb65c9131b359d39a0664f595e9e5a7ef70"
    sha256 x86_64_linux:  "bed5c3d3373fe29ca5a357ac68145f0dc996ccafd6d4f46f33b8af1f38b7aa75"
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
