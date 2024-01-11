class PostgresqlAT15 < Formula
  desc "Object-relational database system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v15.5/postgresql-15.5.tar.bz2"
  sha256 "8f53aa95d78eb8e82536ea46b68187793b42bba3b4f65aa342f540b23c9b10a6"
  license "PostgreSQL"
  revision 2

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(15(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_sonoma:   "f3b8120d9365b29a497b91722877b064ed30a25f06a830317c17e98d78aefb64"
    sha256 arm64_ventura:  "d370d45eaeb01139d375f620b912cfcd3cbeb6791eba79093c6070bdf14ea5db"
    sha256 arm64_monterey: "5a9e29402350c71f7c14590c6c57b617baf485e15d9d82af057f982437f1e7fc"
    sha256 sonoma:         "8aa7b659fa76af970656896d4acbd7dd8aae3e140e68208266a88456eab84a6b"
    sha256 ventura:        "6297417189d430b4e086f81d4141b46aa9a1cfe06528e6245379c51ae8336b9c"
    sha256 monterey:       "a40991f3b6712af1e3f6796bba65329c3d42e3d9b9190099eb289095c1e17378"
    sha256 x86_64_linux:   "de02035687afe638cf626188aa25319697f11f2ac9906a7622f8c3db99ffd803"
  end

  # https://www.postgresql.org/support/versioning/
  deprecate! date: "2027-11-11", because: :unsupported

  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"

  # GSSAPI provided by Kerberos.framework crashes when forked.
  # See https://github.com/Homebrew/homebrew-core/issues/47494.
  depends_on "krb5"

  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "openldap"
  uses_from_macos "perl"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "linux-pam"
    depends_on "util-linux"
  end

  # Fix compatibility with OpenSSL 3.2
  # Remove once merged
  # Ref https://www.postgresql.org/message-id/CX9SU44GH3P4.17X6ZZUJ5D40N%40neon.tech
  patch :DATA

  def install
    ENV.delete "PKG_CONFIG_LIBDIR"
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@3"].opt_lib} -L#{Formula["readline"].opt_lib}"
    ENV.prepend "CPPFLAGS", "-I#{Formula["openssl@3"].opt_include} -I#{Formula["readline"].opt_include}"

    if OS.mac?
      # Fix 'libintl.h' file not found for extensions
      ENV.prepend "LDFLAGS", "-L#{Formula["gettext"].opt_lib}"
      ENV.prepend "CPPFLAGS", "-I#{Formula["gettext"].opt_include}"
    end

    args = std_configure_args + %W[
      --bindir=#{libexec}/bin
      --datadir=#{HOMEBREW_PREFIX}/share/#{name}
      --libdir=#{HOMEBREW_PREFIX}/lib/#{name}
      --includedir=#{HOMEBREW_PREFIX}/include/#{name}
      --sysconfdir=#{etc}
      --docdir=#{doc}
      --mandir=#{libexec}/man
      --enable-nls
      --enable-thread-safety
      --with-gssapi
      --with-icu
      --with-ldap
      --with-libxml
      --with-libxslt
      --with-lz4
      --with-zstd
      --with-openssl
      --with-pam
      --with-perl
      --with-uuid=e2fs
      --with-extra-version=\ (#{tap.user})
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
                                    "libdir=#{lib}/#{name}",
                                    "pkglibdir=#{lib}/#{name}",
                                    "includedir=#{include}/#{name}",
                                    "pkgincludedir=#{include}/#{name}",
                                    "includedir_server=#{include}/#{name}/server",
                                    "includedir_internal=#{include}/#{name}/internal"

    (libexec/"bin").each_child do |f|
      versioned_f = "#{f.basename}-#{version.major}"
      bin.install_symlink f => versioned_f
      manpage = libexec/"man/man1/#{f.basename}.1"
      man1.install_symlink manpage => "#{versioned_f}.1" if manpage.exist?
    end

    if OS.linux?
      inreplace lib/name/"pgxs/src/Makefile.global",
                "LD = #{HOMEBREW_PREFIX}/Homebrew/Library/Homebrew/shims/linux/super/ld",
                "LD = #{HOMEBREW_PREFIX}/bin/ld"
    end
  end

  def post_install
    if linked? && !(HOMEBREW_PREFIX/"bin/psql").exist?
      (libexec/"bin").each_child do |f|
        ln_sf f, bin/f.basename
        ln_sf bin/f.basename, HOMEBREW_PREFIX/"bin"/f.basename
      end
    end

    (var/"log").mkpath
    postgresql_datadir.mkpath

    # Don't initialize database, it clashes when testing other PostgreSQL versions.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "#{bin}/initdb-#{version.major}", "--locale=C", "-E", "UTF-8", postgresql_datadir unless pg_version_exists?
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
        initdb-#{version.major} --locale=C -E UTF-8 #{postgresql_datadir}
      For more details, read:
        https://www.postgresql.org/docs/#{version.major}/app-initdb.html

      Commands have been installed with the suffix "-#{version.major}" to support linking multiple
      PostgreSQL versions. Commands with their normal names may be available if a single
      PostgreSQL is installed. To guarantee normal names, you can update your PATH:
        PATH="#{opt_libexec}/bin:$PATH"
    EOS
  end

  service do
    run [opt_libexec/"bin/postgres", "-D", f.postgresql_datadir]
    environment_variables LC_ALL: "C"
    keep_alive true
    log_path f.postgresql_log_path
    error_log_path f.postgresql_log_path
    working_dir HOMEBREW_PREFIX
  end

  test do
    system "#{bin}/initdb-#{version.major}", testpath/"test" unless ENV["HOMEBREW_GITHUB_ACTIONS"]
    pg_config = "#{bin}/pg_config-#{version.major}"
    assert_equal "#{HOMEBREW_PREFIX}/share/#{name}", shell_output("#{pg_config} --sharedir").chomp
    assert_equal "#{HOMEBREW_PREFIX}/lib/#{name}", shell_output("#{pg_config} --libdir").chomp
    assert_equal "#{HOMEBREW_PREFIX}/lib/#{name}", shell_output("#{pg_config} --pkglibdir").chomp
    assert_equal "#{HOMEBREW_PREFIX}/include/#{name}", shell_output("#{pg_config} --pkgincludedir").chomp
    assert_equal "#{HOMEBREW_PREFIX}/include/#{name}/server", shell_output("#{pg_config} --includedir-server").chomp
    assert_match "-I#{Formula["gettext"].opt_include}", shell_output("#{pg_config} --cppflags") if OS.mac?
  end
end

__END__
diff --git a/src/backend/libpq/be-secure-openssl.c b/src/backend/libpq/be-secure-openssl.c
index f5c5ed210e..aed8a75345 100644
--- a/src/backend/libpq/be-secure-openssl.c
+++ b/src/backend/libpq/be-secure-openssl.c
@@ -839,11 +839,6 @@ be_tls_write(Port *port, void *ptr, size_t len, int *waitfor)
  * to retry; do we need to adopt their logic for that?
  */

-#ifndef HAVE_BIO_GET_DATA
-#define BIO_get_data(bio) (bio->ptr)
-#define BIO_set_data(bio, data) (bio->ptr = data)
-#endif
-
 static BIO_METHOD *my_bio_methods = NULL;

 static int
@@ -853,7 +848,7 @@ my_sock_read(BIO *h, char *buf, int size)

 	if (buf != NULL)
 	{
-		res = secure_raw_read(((Port *) BIO_get_data(h)), buf, size);
+		res = secure_raw_read(((Port *) BIO_get_app_data(h)), buf, size);
 		BIO_clear_retry_flags(h);
 		if (res <= 0)
 		{
@@ -873,7 +868,7 @@ my_sock_write(BIO *h, const char *buf, int size)
 {
 	int			res = 0;

-	res = secure_raw_write(((Port *) BIO_get_data(h)), buf, size);
+	res = secure_raw_write(((Port *) BIO_get_app_data(h)), buf, size);
 	BIO_clear_retry_flags(h);
 	if (res <= 0)
 	{
@@ -949,7 +944,7 @@ my_SSL_set_fd(Port *port, int fd)
 		SSLerr(SSL_F_SSL_SET_FD, ERR_R_BUF_LIB);
 		goto err;
 	}
-	BIO_set_data(bio, port);
+	BIO_set_app_data(bio, port);

 	BIO_set_fd(bio, fd, BIO_NOCLOSE);
 	SSL_set_bio(port->ssl, bio, bio);
diff --git a/src/interfaces/libpq/fe-secure-openssl.c b/src/interfaces/libpq/fe-secure-openssl.c
index af59ff49f7..8d68d023e9 100644
--- a/src/interfaces/libpq/fe-secure-openssl.c
+++ b/src/interfaces/libpq/fe-secure-openssl.c
@@ -1800,11 +1800,6 @@ PQsslAttribute(PGconn *conn, const char *attribute_name)
  * to retry; do we need to adopt their logic for that?
  */

-#ifndef HAVE_BIO_GET_DATA
-#define BIO_get_data(bio) (bio->ptr)
-#define BIO_set_data(bio, data) (bio->ptr = data)
-#endif
-
 static BIO_METHOD *my_bio_methods;

 static int
@@ -1812,7 +1807,7 @@ my_sock_read(BIO *h, char *buf, int size)
 {
 	int			res;

-	res = pqsecure_raw_read((PGconn *) BIO_get_data(h), buf, size);
+	res = pqsecure_raw_read((PGconn *) BIO_get_app_data(h), buf, size);
 	BIO_clear_retry_flags(h);
 	if (res < 0)
 	{
@@ -1842,7 +1837,7 @@ my_sock_write(BIO *h, const char *buf, int size)
 {
 	int			res;

-	res = pqsecure_raw_write((PGconn *) BIO_get_data(h), buf, size);
+	res = pqsecure_raw_write((PGconn *) BIO_get_app_data(h), buf, size);
 	BIO_clear_retry_flags(h);
 	if (res < 0)
 	{
@@ -1933,7 +1928,7 @@ my_SSL_set_fd(PGconn *conn, int fd)
 		SSLerr(SSL_F_SSL_SET_FD, ERR_R_BUF_LIB);
 		goto err;
 	}
-	BIO_set_data(bio, conn);
+	BIO_set_app_data(bio, conn);

 	SSL_set_bio(conn->ssl, bio, bio);
 	BIO_set_fd(bio, fd, BIO_NOCLOSE);
