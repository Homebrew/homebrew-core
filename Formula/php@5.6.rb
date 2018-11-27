class PhpAT56 < Formula
  desc "General-purpose scripting language"
  homepage "https://secure.php.net/"
  url "https://php.net/get/php-5.6.38.tar.xz/from/this/mirror"
  sha256 "c2fac47dc6316bd230f0ea91d8a5498af122fb6a3eb43f796c9ea5f59b04aa1e"
  revision 1

  bottle do
    sha256 "0c89e62cdf0d1a07e1e6a760ba3a84142c12a92f03473f48dcd6f68b4d5fde0a" => :mojave
    sha256 "61967dd1649990abb3150347883f3b3c86a35721683657f83304995e300b097a" => :high_sierra
    sha256 "c23eb4ec745b3253ff6e8f2c6d14eb965b6848e14d1d8651fd3569ae94799261" => :sierra
  end

  keg_only :versioned_formula

  depends_on "httpd" => [:build, :test]
  depends_on "pkg-config" => :build
  depends_on "apr"
  depends_on "apr-util"
  depends_on "aspell"
  depends_on "autoconf"
  depends_on "curl-openssl"
  depends_on "freetds"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gmp"
  depends_on "icu4c"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libtool"
  depends_on "libzip"
  depends_on "mcrypt"
  depends_on "openldap"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "sqlite"
  depends_on "tidy-html5"
  depends_on "unixodbc"

  # PHP build system incorrectly links system libraries
  # see https://github.com/php/php-src/pull/3472
  patch :DATA

  needs :cxx11

  def install
    # Ensure that libxml2 will be detected correctly in older MacOS
    if MacOS.version == :el_capitan || MacOS.version == :sierra
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    # buildconf required due to system library linking bug patch
    system "./buildconf", "--force"

    inreplace "configure" do |s|
      s.gsub! "APACHE_THREADED_MPM=`$APXS_HTTPD -V | grep 'threaded:.*yes'`",
              "APACHE_THREADED_MPM="
      s.gsub! "APXS_LIBEXECDIR='$(INSTALL_ROOT)'`$APXS -q LIBEXECDIR`",
              "APXS_LIBEXECDIR='$(INSTALL_ROOT)#{lib}/httpd/modules'"
      s.gsub! "-z `$APXS -q SYSCONFDIR`",
              "-z ''"
      # apxs will interpolate the @ in the versioned prefix: https://bz.apache.org/bugzilla/show_bug.cgi?id=61944
      s.gsub! "LIBEXECDIR='$APXS_LIBEXECDIR'",
              "LIBEXECDIR='" + "#{lib}/httpd/modules".gsub("@", "\\@") + "'"
    end

    # Update error message in apache sapi to better explain the requirements
    # of using Apache http in combination with php if the non-compatible MPM
    # has been selected. Homebrew has chosen not to support being able to
    # compile a thread safe version of PHP and therefore it is not
    # possible to recompile as suggested in the original message
    inreplace "sapi/apache2handler/sapi_apache2.c",
              "You need to recompile PHP.",
              "Homebrew PHP does not support a thread-safe php binary. "\
              "To use the PHP apache sapi please change "\
              "your httpd config to use the prefork MPM"

    inreplace "sapi/fpm/php-fpm.conf.in", ";daemonize = yes", "daemonize = no"

    # API compatibility with tidy-html5 v5.0.0 - https://github.com/htacg/tidy-html5/issues/224
    inreplace "ext/tidy/tidy.c", "buffio.h", "tidybuffio.h"

    # Required due to icu4c dependency
    ENV.cxx11

    # icu4c 61.1 compatability
    ENV.append "CPPFLAGS", "-DU_USING_ICU_NAMESPACE=1"

    config_path = etc/"php/#{php_version}"
    # Prevent system pear config from inhibiting pear install
    (config_path/"pear.conf").delete if (config_path/"pear.conf").exist?

    # Prevent homebrew from harcoding path to sed shim in phpize script
    ENV["lt_cv_path_SED"] = "sed"

    # Each extension that is built on Mojave needs a direct reference to the
    # sdk path or it won't find the headers
    headers_path = "=#{MacOS.sdk_path_if_needed}/usr"

    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{config_path}
      --with-config-file-path=#{config_path}
      --with-config-file-scan-dir=#{config_path}/conf.d
      --with-pear=#{pkgshare}/pear
      --enable-bcmath
      --enable-calendar
      --enable-dba
      --enable-exif
      --enable-ftp
      --enable-fpm
      --enable-intl
      --enable-mbregex
      --enable-mbstring
      --enable-mysqlnd
      --enable-pcntl
      --enable-phpdbg
      --enable-shmop
      --enable-soap
      --enable-sockets
      --enable-sysvmsg
      --enable-sysvsem
      --enable-sysvshm
      --enable-wddx
      --enable-zip
      --with-apxs2=#{Formula["httpd"].opt_bin}/apxs
      --with-bz2#{headers_path}
      --with-curl=#{Formula["curl-openssl"].opt_prefix}
      --with-fpm-user=_www
      --with-fpm-group=_www
      --with-freetype-dir=#{Formula["freetype"].opt_prefix}
      --with-gd
      --with-gettext=#{Formula["gettext"].opt_prefix}
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-iconv#{headers_path}
      --with-icu-dir=#{Formula["icu4c"].opt_prefix}
      --with-jpeg-dir=#{Formula["jpeg"].opt_prefix}
      --with-kerberos#{headers_path}
      --with-layout=GNU
      --with-ldap=#{Formula["openldap"].opt_prefix}
      --with-ldap-sasl#{headers_path}
      --with-libedit#{headers_path}
      --with-libxml-dir#{headers_path}
      --with-libzip
      --with-mcrypt=#{Formula["mcrypt"].opt_prefix}
      --with-mhash#{headers_path}
      --with-mysql-sock=/tmp/mysql.sock
      --with-mysqli=mysqlnd
      --with-mysql=mysqlnd
      --with-ndbm#{headers_path}
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-pdo-dblib=#{Formula["freetds"].opt_prefix}
      --with-pdo-mysql=mysqlnd
      --with-pdo-odbc=unixODBC,#{Formula["unixodbc"].opt_prefix}
      --with-pdo-pgsql=#{Formula["libpq"].opt_prefix}
      --with-pdo-sqlite=#{Formula["sqlite"].opt_prefix}
      --with-pgsql=#{Formula["libpq"].opt_prefix}
      --with-pic
      --with-png-dir=#{Formula["libpng"].opt_prefix}
      --with-pspell=#{Formula["aspell"].opt_prefix}
      --with-sqlite3=#{Formula["sqlite"].opt_prefix}
      --with-tidy=#{Formula["tidy-html5"].opt_prefix}
      --with-unixODBC=#{Formula["unixodbc"].opt_prefix}
      --with-xmlrpc
      --with-xsl#{headers_path}
      --with-zlib#{headers_path}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"

    # Allow pecl to install outside of Cellar
    extension_dir = Utils.popen_read("#{bin}/php-config --extension-dir").chomp
    orig_ext_dir = File.basename(extension_dir)
    inreplace bin/"php-config", lib/"php", prefix/"pecl"
    inreplace "php.ini-development", %r{; ?extension_dir = "\./"},
      "extension_dir = \"#{HOMEBREW_PREFIX}/lib/php/pecl/#{orig_ext_dir}\""

    config_files = {
      "php.ini-development"   => "php.ini",
      "sapi/fpm/php-fpm.conf" => "php-fpm.conf",
    }
    config_files.each_value do |dst|
      dst_default = config_path/"#{dst}.default"
      rm dst_default if dst_default.exist?
    end
    config_path.install config_files

    unless (var/"log/php-fpm.log").exist?
      (var/"log").mkpath
      touch var/"log/php-fpm.log"
    end
  end

  def post_install
    pear_prefix = pkgshare/"pear"
    pear_files = %W[
      #{pear_prefix}/.depdblock
      #{pear_prefix}/.filemap
      #{pear_prefix}/.depdb
      #{pear_prefix}/.lock
    ]

    %W[
      #{pear_prefix}/.channels
      #{pear_prefix}/.channels/.alias
    ].each do |f|
      chmod 0755, f
      pear_files.concat(Dir["#{f}/*"])
    end

    chmod 0644, pear_files

    # Custom location for extensions installed via pecl
    pecl_path = HOMEBREW_PREFIX/"lib/php/pecl"
    ln_s pecl_path, prefix/"pecl" unless (prefix/"pecl").exist?
    extension_dir = Utils.popen_read("#{bin}/php-config --extension-dir").chomp
    php_basename = File.basename(extension_dir)
    php_ext_dir = opt_prefix/"lib/php"/php_basename

    # fix pear config to install outside cellar
    pear_path = HOMEBREW_PREFIX/"share/pear@#{php_version}"
    cp_r pkgshare/"pear/.", pear_path
    {
      "php_ini"  => etc/"php/#{php_version}/php.ini",
      "php_dir"  => pear_path,
      "doc_dir"  => pear_path/"doc",
      "ext_dir"  => pecl_path/php_basename,
      "bin_dir"  => opt_bin,
      "data_dir" => pear_path/"data",
      "cfg_dir"  => pear_path/"cfg",
      "www_dir"  => pear_path/"htdocs",
      "man_dir"  => HOMEBREW_PREFIX/"share/man",
      "test_dir" => pear_path/"test",
      "php_bin"  => opt_bin/"php",
    }.each do |key, value|
      value.mkpath if key =~ /(?<!bin|man)_dir$/
      system bin/"pear", "config-set", key, value, "system"
    end

    system bin/"pear", "update-channels"

    %w[
      opcache
    ].each do |e|
      ext_config_path = etc/"php/#{php_version}/conf.d/ext-#{e}.ini"
      extension_type = (e == "opcache") ? "zend_extension" : "extension"
      if ext_config_path.exist?
        inreplace ext_config_path,
          /#{extension_type}=.*$/, "#{extension_type}=#{php_ext_dir}/#{e}.so"
      else
        ext_config_path.write <<~EOS
          [#{e}]
          #{extension_type}="#{php_ext_dir}/#{e}.so"
        EOS
      end
    end
  end

  def caveats
    <<~EOS
      To enable PHP in Apache add the following to httpd.conf and restart Apache:
          LoadModule php5_module #{opt_lib}/httpd/modules/libphp5.so

          <FilesMatch \\.php$>
              SetHandler application/x-httpd-php
          </FilesMatch>

      Finally, check DirectoryIndex includes index.php
          DirectoryIndex index.php index.html

      The php.ini and php-fpm.ini file can be found in:
          #{etc}/php/#{php_version}/
    EOS
  end

  def php_version
    version.to_s.split(".")[0..1].join(".")
  end

  plist_options :manual => "php-fpm"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/php-fpm</string>
          <string>--nodaemonize</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/php-fpm.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    assert_match /^Zend OPcache$/, shell_output("#{bin}/php -i"),
      "Zend OPCache extension not loaded"
    # Test related to libxml2 and
    # https://github.com/Homebrew/homebrew-core/issues/28398
    assert_includes MachO::Tools.dylibs("#{bin}/php"),
      "#{Formula["libpq"].opt_lib}/libpq.5.dylib"
    system "#{sbin}/php-fpm", "-t"
    system "#{bin}/phpdbg", "-V"
    system "#{bin}/php-cgi", "-m"
    # Prevent SNMP extension to be added
    assert_no_match /^snmp$/, shell_output("#{bin}/php -m"),
      "SNMP extension doesn't work reliably with Homebrew on High Sierra"
    begin
      require "socket"

      server = TCPServer.new(0)
      port = server.addr[1]
      server_fpm = TCPServer.new(0)
      port_fpm = server_fpm.addr[1]
      server.close
      server_fpm.close

      expected_output = /^Hello world!$/
      (testpath/"index.php").write <<~EOS
        <?php
        echo 'Hello world!' . PHP_EOL;
        var_dump(ldap_connect());
      EOS
      main_config = <<~EOS
        Listen #{port}
        ServerName localhost:#{port}
        DocumentRoot "#{testpath}"
        ErrorLog "#{testpath}/httpd-error.log"
        ServerRoot "#{Formula["httpd"].opt_prefix}"
        PidFile "#{testpath}/httpd.pid"
        LoadModule authz_core_module lib/httpd/modules/mod_authz_core.so
        LoadModule unixd_module lib/httpd/modules/mod_unixd.so
        LoadModule dir_module lib/httpd/modules/mod_dir.so
        DirectoryIndex index.php
      EOS

      (testpath/"httpd.conf").write <<~EOS
        #{main_config}
        LoadModule mpm_prefork_module lib/httpd/modules/mod_mpm_prefork.so
        LoadModule php5_module #{lib}/httpd/modules/libphp5.so
        <FilesMatch \\.(php|phar)$>
          SetHandler application/x-httpd-php
        </FilesMatch>
      EOS

      (testpath/"fpm.conf").write <<~EOS
        [global]
        daemonize=no
        [www]
        listen = 127.0.0.1:#{port_fpm}
        pm = dynamic
        pm.max_children = 5
        pm.start_servers = 2
        pm.min_spare_servers = 1
        pm.max_spare_servers = 3
      EOS

      (testpath/"httpd-fpm.conf").write <<~EOS
        #{main_config}
        LoadModule mpm_event_module lib/httpd/modules/mod_mpm_event.so
        LoadModule proxy_module lib/httpd/modules/mod_proxy.so
        LoadModule proxy_fcgi_module lib/httpd/modules/mod_proxy_fcgi.so
        <FilesMatch \\.(php|phar)$>
          SetHandler "proxy:fcgi://127.0.0.1:#{port_fpm}"
        </FilesMatch>
      EOS

      pid = fork do
        exec Formula["httpd"].opt_bin/"httpd", "-X", "-f", "#{testpath}/httpd.conf"
      end
      sleep 3

      assert_match expected_output, shell_output("curl -s 127.0.0.1:#{port}")

      Process.kill("TERM", pid)
      Process.wait(pid)

      fpm_pid = fork do
        exec sbin/"php-fpm", "-y", "fpm.conf"
      end
      pid = fork do
        exec Formula["httpd"].opt_bin/"httpd", "-X", "-f", "#{testpath}/httpd-fpm.conf"
      end
      sleep 3

      assert_match expected_output, shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      if pid
        Process.kill("TERM", pid)
        Process.wait(pid)
      end
      if fpm_pid
        Process.kill("TERM", fpm_pid)
        Process.wait(fpm_pid)
      end
    end
  end
end

__END__
diff --git a/acinclude.m4 b/acinclude.m4
index 168c465f8d..6c087d152f 100644
--- a/acinclude.m4
+++ b/acinclude.m4
@@ -441,7 +441,11 @@ dnl
 dnl Adds a path to linkpath/runpath (LDFLAGS)
 dnl
 AC_DEFUN([PHP_ADD_LIBPATH],[
-  if test "$1" != "/usr/$PHP_LIBDIR" && test "$1" != "/usr/lib"; then
+  case "$1" in
+  "/usr/$PHP_LIBDIR"|"/usr/lib"[)] ;;
+  /Library/Developer/CommandLineTools/SDKs/*/usr/lib[)] ;;
+  /Applications/Xcode*.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/*/usr/lib[)] ;;
+  *[)]
     PHP_EXPAND_PATH($1, ai_p)
     ifelse([$2],,[
       _PHP_ADD_LIBPATH_GLOBAL([$ai_p])
@@ -452,8 +456,8 @@ AC_DEFUN([PHP_ADD_LIBPATH],[
       else
         _PHP_ADD_LIBPATH_GLOBAL([$ai_p])
       fi
-    ])
-  fi
+    ]) ;;
+  esac
 ])

 dnl
@@ -487,7 +491,11 @@ dnl add an include path.
 dnl if before is 1, add in the beginning of INCLUDES.
 dnl
 AC_DEFUN([PHP_ADD_INCLUDE],[
-  if test "$1" != "/usr/include"; then
+  case "$1" in
+  "/usr/include"[)] ;;
+  /Library/Developer/CommandLineTools/SDKs/*/usr/include[)] ;;
+  /Applications/Xcode*.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/*/usr/include[)] ;;
+  *[)]
     PHP_EXPAND_PATH($1, ai_p)
     PHP_RUN_ONCE(INCLUDEPATH, $ai_p, [
       if test "$2"; then
@@ -495,8 +503,8 @@ AC_DEFUN([PHP_ADD_INCLUDE],[
       else
         INCLUDES="$INCLUDES -I$ai_p"
       fi
-    ])
-  fi
+    ]) ;;
+  esac
 ])

 dnl internal, don't use
@@ -2411,7 +2419,8 @@ AC_DEFUN([PHP_SETUP_ICONV], [
     fi

     if test -f $ICONV_DIR/$PHP_LIBDIR/lib$iconv_lib_name.a ||
-       test -f $ICONV_DIR/$PHP_LIBDIR/lib$iconv_lib_name.$SHLIB_SUFFIX_NAME
+       test -f $ICONV_DIR/$PHP_LIBDIR/lib$iconv_lib_name.$SHLIB_SUFFIX_NAME ||
+       test -f $ICONV_DIR/$PHP_LIBDIR/lib$iconv_lib_name.tbd
     then
       PHP_CHECK_LIBRARY($iconv_lib_name, libiconv, [
         found_iconv=yes
diff --git a/Zend/zend_compile.h b/Zend/zend_compile.h
index a0955e34fe..09b4984f90 100644
--- a/Zend/zend_compile.h
+++ b/Zend/zend_compile.h
@@ -414,9 +414,6 @@ struct _zend_execute_data {

 #define EX(element) execute_data.element

-#define EX_TMP_VAR(ex, n)	   ((temp_variable*)(((char*)(ex)) + ((int)(n))))
-#define EX_TMP_VAR_NUM(ex, n)  (EX_TMP_VAR(ex, 0) - (1 + (n)))
-
 #define EX_CV_NUM(ex, n)       (((zval***)(((char*)(ex))+ZEND_MM_ALIGNED_SIZE(sizeof(zend_execute_data))))+(n))


diff --git a/Zend/zend_execute.h b/Zend/zend_execute.h
index a7af67bc13..ae71a5c73f 100644
--- a/Zend/zend_execute.h
+++ b/Zend/zend_execute.h
@@ -71,6 +71,15 @@ ZEND_API int zend_eval_stringl_ex(char *str, int str_len, zval *retval_ptr, char
 ZEND_API char * zend_verify_arg_class_kind(const zend_arg_info *cur_arg_info, ulong fetch_type, const char **class_name, zend_class_entry **pce TSRMLS_DC);
 ZEND_API int zend_verify_arg_error(int error_type, const zend_function *zf, zend_uint arg_num, const char *need_msg, const char *need_kind, const char *given_msg, const char *given_kind TSRMLS_DC);

+static zend_always_inline temp_variable *EX_TMP_VAR(void *ex, int n)
+{
+	return (temp_variable *)((zend_uintptr_t)ex + n);
+}
+static inline temp_variable *EX_TMP_VAR_NUM(void *ex, int n)
+{
+	return (temp_variable *)((zend_uintptr_t)ex - (1 + n) * sizeof(temp_variable));
+}
+
 static zend_always_inline void i_zval_ptr_dtor(zval *zval_ptr ZEND_FILE_LINE_DC TSRMLS_DC)
 {
	if (!Z_DELREF_P(zval_ptr)) {
