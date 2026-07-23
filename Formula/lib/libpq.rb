class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/current/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v18.4/postgresql-18.4.tar.bz2"
  sha256 "81a81ec695fb0c7901407defaa1d2f7973617154cf27ba74e3a7ab8e64436094"
  license "PostgreSQL"
  compatibility_version 1

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "dc42d07661bb1abb1f023155fc506db7f61e5dcdbb236048654540699e4f1ee5"
    sha256 arm64_sequoia: "1647097313da545e3742d17f2b9875a941079a96be8d743d1d11316895fa25d7"
    sha256 arm64_sonoma:  "ee5d207f0924b765f19f7dda6802abc11aed8d790b8bc6b07564b3bfdddf6143"
    sha256 sonoma:        "9a0549142e54c7aeaf023087a64729704e9209d200b867dd18aa0d8f072728fa"
    sha256 arm64_linux:   "01389abb039d97d3178066b12a696c02151b767f0979e9ad520a993ddf6af9df"
    sha256 x86_64_linux:  "6ba1e7e120c0e8208738bab6e22cf1adf316e7c1e299cc006454648dfbea7cc7"
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
