class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/current/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v16.4/postgresql-16.4.tar.bz2"
  sha256 "971766d645aa73e93b9ef4e3be44201b4f45b5477095b049125403f9f3386d6f"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sonoma:   "5cba324d7dbc763dc432f818202484e06ec870bfaf715ad19ca6871dc7b75c05"
    sha256 arm64_ventura:  "62dd2f49e9640e9640120ee3083c8f219f2fe2461e5f8a8a5a4ec8391f0db964"
    sha256 arm64_monterey: "e07a4c790f4636657b8cd1b3a8aa2ea2d2577b730155f652891adcc6289dc034"
    sha256 sonoma:         "2b117f12c88d4f2997d3bf4f301b573463404647318b37c29258c3dd19d6917a"
    sha256 ventura:        "de4417cac91699e60bdac34b0149e546cf93ea1b2980a7266fcb55bf79517ec9"
    sha256 monterey:       "ac626a8e1367aea8de8baa98c631155ecde517c4f68c56996ebab1d4be46cc7c"
    sha256 x86_64_linux:   "5daa7fec5ec79c409374861c339882727ada3d5691f3ba97cbe06525a6213f08"
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
