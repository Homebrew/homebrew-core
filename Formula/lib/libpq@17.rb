class LibpqAT17 < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/17/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v17.9/postgresql-17.9.tar.bz2"
  sha256 "3b9a62538a8da151e807a3ddb1198e8605f2032544d78f403ae883d27ecf1ee4"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(17(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "18d66cdaf01865d8cd66e0a82314c7d4971ce47339fcd143df25947f66231821"
    sha256 arm64_sequoia: "d8ccaaa7807af311cd271ef2adc1e97c704a916e14da64819e8282b2f5ac7cca"
    sha256 arm64_sonoma:  "5c446b09f979caddb24a56e108009c309ffafbd8c3aff40dfa4de797cc747a2d"
    sha256 sonoma:        "9805aadf1206a4923691baa104b8819670897ecf5721e82ff8cb6f18a4bd3bed"
    sha256 arm64_linux:   "d92840086748e86d357146e9491be72def4ca025a2e2b7c0b83374455b8329f7"
    sha256 x86_64_linux:  "1d93fd1892634a7edfc9f37c8fa1ba2168b36796c43418207dcfdad843269956"
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
