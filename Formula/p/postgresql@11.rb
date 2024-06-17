class PostgresqlAT11 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v11.22/postgresql-11.22.tar.bz2"
  sha256 "2cb7c97d7a0d7278851bbc9c61f467b69c094c72b81740b751108e7892ebe1f0"
  license "PostgreSQL"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "2a56ef05e144bbb7fa75581220ec03c19b26409385e8e04607c490a315de53cc"
    sha256 arm64_ventura:  "ea9b6c5caf216c1f670aeac7af0af4aa294096fa9ce3645b87b689f4776de55f"
    sha256 arm64_monterey: "44ad100d072df24959e8c8cbf111a6995beb9542bab9e200cab0ff2703d1594e"
    sha256 sonoma:         "952beb2f8aa1c1c9c4df4d64ab29951cc3b3fa15d2855f2f97d9d6e78c34579e"
    sha256 ventura:        "05eac68a15e43c5acfa7bcb90dfda69a24651a69b540bab0b8df543d015242e3"
    sha256 monterey:       "01c2aadb78c4dbc52e6ff83c92d1ea134c4945c59ad97b1a57741a0dd6222c32"
    sha256 x86_64_linux:   "15384b5b5a2f147ab820f73c24802d6812338cc8949aae864bcbad51af6e1cf3"
  end

  keg_only :versioned_formula

  # https://www.postgresql.org/support/versioning/
  deprecate! date: "2023-11-09", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "icu4c"
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

    system "#{bin}/initdb", "--locale=C", "-E", "UTF-8", postgresql_datadir unless pg_version_exists?
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
    system "#{bin}/initdb", testpath/"test" unless ENV["HOMEBREW_GITHUB_ACTIONS"]
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
