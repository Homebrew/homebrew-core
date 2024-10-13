class PostgresqlAT11 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v11.22/postgresql-11.22.tar.bz2"
  sha256 "2cb7c97d7a0d7278851bbc9c61f467b69c094c72b81740b751108e7892ebe1f0"
  license "PostgreSQL"
  revision 2

  bottle do
    sha256 arm64_sequoia: "48826bee58bcadc0a4b18d8d29035f6a2d0d3db6aca0a3a3092737e1c61ac172"
    sha256 arm64_sonoma:  "907b7dbc60759c0c57190cafb731e0c2f21656c57446e840e1b196b6c9328411"
    sha256 arm64_ventura: "03cb9eeca30faca0fb2ec618d06ba1586131946369719b5f8e2b26164cd82918"
    sha256 sonoma:        "073b6df762a77ad05e26432acf5ba013bfbbb3eef3422a5ca9b92bedae3f20e3"
    sha256 ventura:       "a26c992b153361df8807d93c2edad126fef8a0ddb14e2be66aa2cf843ce01698"
    sha256 x86_64_linux:  "9d4313a790a776e4ed357c0778d00d17575ebef3f19dde4aca7dc8c546ffcd80"
  end

  keg_only :versioned_formula

  # https://www.postgresql.org/support/versioning/
  deprecate! date: "2023-11-09", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "icu4c@75"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "krb5"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "openldap"
  uses_from_macos "perl"

  on_linux do
    depends_on "linux-pam"
    depends_on "util-linux"
  end

  # Fix compatibility with OpenSSL 3.2
  # Ref https://www.postgresql.org/message-id/CX9SU44GH3P4.17X6ZZUJ5D40N%40neon.tech
  patch :DATA

  def install
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@3"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@3"].opt_include} -I#{Formula["readline"].opt_include}"

    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --datadir=#{opt_pkgshare}
      --libdir=#{opt_lib}
      --includedir=#{opt_include}
      --sysconfdir=#{etc}
      --docdir=#{doc}
      --enable-thread-safety
      --with-gssapi
      --with-icu
      --with-ldap
      --with-libxml
      --with-libxslt
      --with-openssl
      --with-pam
      --with-perl
      --with-uuid=e2fs
    ]
    if OS.mac?
      args += %w[
        --with-bonjour
        --with-tcl
      ]
    end

    # PostgreSQL by default uses xcodebuild internally to determine this,
    # which does not work on CLT-only installs.
    args << "PG_SYSROOT=#{MacOS.sdk_path}" if OS.mac? && MacOS.sdk_root_needed?

    system "./configure", *args
    system "make"
    system "make", "install-world", "datadir=#{pkgshare}",
                                    "libdir=#{lib}",
                                    "pkglibdir=#{lib}",
                                    "includedir=#{include}",
                                    "pkgincludedir=#{include}",
                                    "includedir_server=#{include}/server",
                                    "includedir_internal=#{include}/internal"

    if OS.linux?
      inreplace lib/"pgxs/src/Makefile.global",
                "LD = #{HOMEBREW_PREFIX}/Homebrew/Library/Homebrew/shims/linux/super/ld",
                "LD = #{HOMEBREW_PREFIX}/bin/ld"
    end
  end

  def post_install
    (var/"log").mkpath
    postgresql_datadir.mkpath

    # Don't initialize database, it clashes when testing other PostgreSQL versions.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"initdb", "--locale=C", "-E", "UTF-8", postgresql_datadir unless pg_version_exists?
  end

  def postgresql_datadir
    var/name
  end

  def postgresql_log_path
    var/"log/#{name}.log"
  end

  def pg_version_exists?
    (postgresql_datadir/"PG_VERSION").exist?
  end

  def caveats
    <<~EOS
      This formula has created a default database cluster with:
        initdb --locale=C -E UTF-8 #{postgresql_datadir}
      For more details, read:
        https://www.postgresql.org/docs/#{version.major}/app-initdb.html
    EOS
  end

  service do
    run [opt_bin/"postgres", "-D", f.postgresql_datadir]
    keep_alive true
    log_path f.postgresql_log_path
    error_log_path f.postgresql_log_path
    working_dir HOMEBREW_PREFIX
  end

  test do
    system bin/"initdb", testpath/"test" unless ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_equal opt_pkgshare.to_s, shell_output("#{bin}/pg_config --sharedir").chomp
    assert_equal opt_lib.to_s, shell_output("#{bin}/pg_config --libdir").chomp
    assert_equal opt_lib.to_s, shell_output("#{bin}/pg_config --pkglibdir").chomp
  end
end

__END__
diff --git a/src/backend/libpq/be-secure-openssl.c b/src/backend/libpq/be-secure-openssl.c
index e307bfea82..255f5d61b7 100644
--- a/src/backend/libpq/be-secure-openssl.c
+++ b/src/backend/libpq/be-secure-openssl.c
@@ -663,11 +663,6 @@ be_tls_write(Port *port, void *ptr, size_t len, int *waitfor)
  * to retry; do we need to adopt their logic for that?
  */

-#ifndef HAVE_BIO_GET_DATA
-#define BIO_get_data(bio) (bio->ptr)
-#define BIO_set_data(bio, data) (bio->ptr = data)
-#endif
-
 static BIO_METHOD *my_bio_methods = NULL;

 static int
@@ -677,7 +672,7 @@ my_sock_read(BIO *h, char *buf, int size)

 	if (buf != NULL)
 	{
-		res = secure_raw_read(((Port *) BIO_get_data(h)), buf, size);
+		res = secure_raw_read(((Port *) BIO_get_app_data(h)), buf, size);
 		BIO_clear_retry_flags(h);
 		if (res <= 0)
 		{
@@ -697,7 +692,7 @@ my_sock_write(BIO *h, const char *buf, int size)
 {
 	int			res = 0;

-	res = secure_raw_write(((Port *) BIO_get_data(h)), buf, size);
+	res = secure_raw_write(((Port *) BIO_get_app_data(h)), buf, size);
 	BIO_clear_retry_flags(h);
 	if (res <= 0)
 	{
@@ -773,7 +768,7 @@ my_SSL_set_fd(Port *port, int fd)
 		SSLerr(SSL_F_SSL_SET_FD, ERR_R_BUF_LIB);
 		goto err;
 	}
-	BIO_set_data(bio, port);
+	BIO_set_app_data(bio, port);

 	BIO_set_fd(bio, fd, BIO_NOCLOSE);
 	SSL_set_bio(port->ssl, bio, bio);
diff --git a/src/interfaces/libpq/fe-secure-openssl.c b/src/interfaces/libpq/fe-secure-openssl.c
index 55e231e849..bf091c0ec5 100644
--- a/src/interfaces/libpq/fe-secure-openssl.c
+++ b/src/interfaces/libpq/fe-secure-openssl.c
@@ -1491,11 +1491,6 @@ PQsslAttribute(PGconn *conn, const char *attribute_name)
  * to retry; do we need to adopt their logic for that?
  */

-#ifndef HAVE_BIO_GET_DATA
-#define BIO_get_data(bio) (bio->ptr)
-#define BIO_set_data(bio, data) (bio->ptr = data)
-#endif
-
 static BIO_METHOD *my_bio_methods;

 static int
@@ -1503,7 +1498,7 @@ my_sock_read(BIO *h, char *buf, int size)
 {
 	int			res;

-	res = pqsecure_raw_read((PGconn *) BIO_get_data(h), buf, size);
+	res = pqsecure_raw_read((PGconn *) BIO_get_app_data(h), buf, size);
 	BIO_clear_retry_flags(h);
 	if (res < 0)
 	{
@@ -1533,7 +1528,7 @@ my_sock_write(BIO *h, const char *buf, int size)
 {
 	int			res;

-	res = pqsecure_raw_write((PGconn *) BIO_get_data(h), buf, size);
+	res = pqsecure_raw_write((PGconn *) BIO_get_app_data(h), buf, size);
 	BIO_clear_retry_flags(h);
 	if (res <= 0)
 	{
@@ -1624,7 +1619,7 @@ my_SSL_set_fd(PGconn *conn, int fd)
 		SSLerr(SSL_F_SSL_SET_FD, ERR_R_BUF_LIB);
 		goto err;
 	}
-	BIO_set_data(bio, conn);
+	BIO_set_app_data(bio, conn);

 	SSL_set_bio(conn->ssl, bio, bio);
 	BIO_set_fd(bio, fd, BIO_NOCLOSE);
