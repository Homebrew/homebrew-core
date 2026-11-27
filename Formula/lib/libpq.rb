class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/current/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v19.0/postgresql-19.0.tar.bz2"
  sha256 "a89fd70efbad6a08c7dbed8d4872e3af30170d9e5ca9dc7906523be95b4e692d"
  license "PostgreSQL"
  compatibility_version 1

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    manifest_sha256 "3d63113127567d2bf03715e64dafb065dc2a142738873f6fe248070cc1de0b29"
    sha256 arm64_golden_gate: "3b29585438499645bb5a0f3d72f98e579bc2bcf0751c5cb70e80d1190754a30e"
    sha256 arm64_tahoe:       "6b63fb160d9cc1fd4788b130da24af96a7b9b5a779edbc5072f4d683d5e5ab47"
    sha256 arm64_sequoia:     "0f7195c10825b1d24cb826d54419e387eb80a403d21d25637f465c0ad5f11f88"
    sha256 arm64_linux:       "14bb17803af8567fbe120e5477c5754cc8815a461a1349972a071da021132b8f"
    sha256 x86_64_linux:      "39e19a95340524358dc5d7aadd4e931875276a645be0fd451893589c8c5bfdc8"
  end

  keg_only "it conflicts with PostgreSQL"

  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
  depends_on "icu4c@79"
  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"
  depends_on "openssl@4"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
