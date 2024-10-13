class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.2.3.tar.gz"
  sha256 "a1957826fab7725484fc5b74780a6a7d0d8b7f5e2e54d26e106b399e0a86beb0"
  license "GPL-3.0-only"
  revision 5

  livecheck do
    url :homepage
    regex(%r{href=.*?dist/libzdb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "c97a8bf09b5b6149e9b00055c7a41bdc44d30d24dba89057d10c692c66775ac8"
    sha256 cellar: :any,                 arm64_sonoma:  "0b8ddfd01835494761c61f79bbf0268ed9970eda906751f394345132ee8f1e99"
    sha256 cellar: :any,                 arm64_ventura: "2a68a90b4ae8eaf45dce9319688be51e9cbbed3f8906492641b04d7b03db03b2"
    sha256 cellar: :any,                 sonoma:        "a60352d7b1e4544558bb754abfa0d792f4b30dec3ef8e3d36243885fde8005c2"
    sha256 cellar: :any,                 ventura:       "a1d91f504e85283dade237952dd3872e28d253065de94e63ee3dd1b1509dfab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eac6ae172d51fd94fc04a71798011d683d07d46f0e52b5de22968289e74fd01a"
  end

  depends_on "libpq"
  depends_on macos: :high_sierra # C++ 17 is required
  depends_on "mysql-client"
  depends_on "sqlite"

  patch :DATA # Fix build error my mysql-client 8.3.0 https://bitbucket.org/tildeslash/libzdb/issues/67/build-error-with-mysql-83

  def install
    # Reduce linkage on macOS from `mysql-client`
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

    system "./configure", "--disable-silent-rules", "--enable-sqliteunlock", *std_configure_args
    system "make", "install"
    (pkgshare/"test").install Dir["test/*.{c,cpp}"]
  end

  test do
    cp_r pkgshare/"test", testpath
    cd "test" do
      system ENV.cc, "select.c", "-L#{lib}", "-lpthread", "-lzdb", "-I#{include}/zdb", "-o", "select"
      system "./select"
    end
  end
end

__END__
diff --git a/src/db/mysql/MysqlConnection.c b/src/db/mysql/MysqlConnection.c
index 45ae896..7b6c1e3 100644
--- a/src/db/mysql/MysqlConnection.c
+++ b/src/db/mysql/MysqlConnection.c
@@ -96,8 +96,10 @@ static MYSQL *_doConnect(Connection_T delegator, char **error) {
         // Options
         if (IS(URL_getParameter(url, "compress"), "true"))
                 clientFlags |= CLIENT_COMPRESS;
-        if (IS(URL_getParameter(url, "use-ssl"), "true"))
-                mysql_ssl_set(db, 0,0,0,0,0);
+        if (IS(URL_getParameter(url, "use-ssl"), "true")) {
+                enum mysql_ssl_mode ssl_mode = SSL_MODE_REQUIRED;
+                mysql_options(db, MYSQL_OPT_SSL_MODE, &ssl_mode);
+        }
 #if MYSQL_VERSION_ID < 80000
         if (IS(URL_getParameter(url, "secure-auth"), "true"))
                 mysql_options(db, MYSQL_SECURE_AUTH, (const char*)&yes);
