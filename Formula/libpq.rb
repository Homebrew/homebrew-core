class Libpq < Formula
  desc "Postgres C API library"
  homepage "https://www.postgresql.org/docs/15/libpq.html"
  url "https://ftp.postgresql.org/pub/source/v15.3/postgresql-15.3.tar.bz2"
  sha256 "ffc7d4891f00ffbf5c3f4eab7fbbced8460b8c0ee63c5a5167133b9e6599d932"
  license "PostgreSQL"
  revision 1

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_ventura:  "5c212c4a2ed21cfe75a18e319e5586f3cd959ad0a578308f167e0b3f38e5321c"
    sha256 arm64_monterey: "aa7e5fb59c2358c77faded217e99350c0efe46b8b35d5cc836f783f79e73f526"
    sha256 arm64_big_sur:  "72818938ff45316befe30678f60c806d1f84d3836e84cca4a80aa42c6af9f8bc"
    sha256 ventura:        "2e96f0ba51e6aea46ce23fecfc028a7fd561e30b36310307ed6ef8e6608d31fe"
    sha256 monterey:       "b350a20184976f9130aec1b5af0d13a91b8331e9e745b1f9652e435f17a0a19a"
    sha256 big_sur:        "8da370c2a046ab56329a2e82964f702dbf9ddff57319fba7be500c38d3f78abb"
    sha256 x86_64_linux:   "c43e007488f9b2de539ae8c1f0a7a58e2fa34c73c42aebe269dc79fab0d8cc52"
  end

  keg_only "conflicts with postgres formula"

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
