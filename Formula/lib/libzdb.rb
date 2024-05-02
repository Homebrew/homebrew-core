class Libzdb < Formula
  desc "Database connection pool library"
  homepage "https://tildeslash.com/libzdb/"
  url "https://tildeslash.com/libzdb/dist/libzdb-3.2.3.tar.gz"
  sha256 "a1957826fab7725484fc5b74780a6a7d0d8b7f5e2e54d26e106b399e0a86beb0"
  license "GPL-3.0-only"
  revision 4

  livecheck do
    url :homepage
    regex(%r{href=.*?dist/libzdb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c33a3c53872c2cf138d6d36a30697feb3c772df7c3af38b18d06011b5c3dd1b3"
    sha256 cellar: :any,                 arm64_ventura:  "9ced34617c452cd53fbb22fac4a25b00a7f747efe87bde70d8fac53478c94c19"
    sha256 cellar: :any,                 arm64_monterey: "60a30c4782d5683eb45f4e516eddc2e826eae8e0be59496ab7b82d2775417244"
    sha256 cellar: :any,                 sonoma:         "077224340fa1ac1f8cb9842ae4aa0db9cf306f0540189ecd1c16c298f2aa5e86"
    sha256 cellar: :any,                 ventura:        "129e3bf0325c241fb4f8ae144c90e8e53845ada18ca753019d5705a22eca4148"
    sha256 cellar: :any,                 monterey:       "645af9d42c7d9fb7b012f42bb2181d876f9b36e678cfd9441d8b74379c8eec8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "787ffbba1df2908f13390d16ce3ffac1976f2f2acd937e3b2b33bc3f5af16fe4"
  end

  depends_on "libpq"
  depends_on macos: :high_sierra # C++ 17 is required
  depends_on "mysql-client"
  depends_on "openssl@3"
  depends_on "sqlite"

  fails_with gcc: "5"

  patch :DATA # Fix build error my mysql-client 8.3.0 https://bitbucket.org/tildeslash/libzdb/issues/67/build-error-with-mysql-83

  def install
    system "./configure", *std_configure_args
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
