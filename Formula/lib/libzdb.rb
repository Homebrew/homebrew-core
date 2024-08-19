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
    sha256 cellar: :any,                 arm64_sonoma:   "3b5c6db79896a7353c41b2a8415a718db42e7653cf2e8173aad1e051094fee55"
    sha256 cellar: :any,                 arm64_ventura:  "7ac2411249ff9931effb968e5d90d3afcab3367cfa967e06c432cb54f83e8f87"
    sha256 cellar: :any,                 arm64_monterey: "5c68468472d5674dbbbad4c6b135874b512add3ab4da70d8fc39877a242236af"
    sha256 cellar: :any,                 sonoma:         "5fb1183dd63ab68fe2b9950ba8b5b6573c359a9696eb604973e135c37dc18a2a"
    sha256 cellar: :any,                 ventura:        "d1093fca14675094c5ee76a56a26a0d1940baea3aa1bce5778c8780f4cb20992"
    sha256 cellar: :any,                 monterey:       "42defdd2bcfb137b12c3ccd858071293b77357dce9252ea0a41e4c66022a44a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b7fcc0e587c5370091190d157fbc725cf4ad4d9373904092878a7aa88746228"
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
