class PhpAT84 < Formula
  desc "General-purpose scripting language"
  homepage "https://www.php.net/"
  # Should only be updated if the new version is announced on the homepage, https://www.php.net/
  url "https://www.php.net/distributions/php-8.4.23.tar.xz"
  mirror "https://fossies.org/linux/www/php-8.4.23.tar.xz"
  sha256 "1ab9f52008414e43bb2427ffa288eff2a4de39e1a830f957e800ba368d887a72"
  license all_of: [
    "PHP-3.01",

    # Extra licenses not documented in README.REDIST.BINS
    "Zend-2.0", # Zend/LICENSE
    "BSL-1.0",  # Zend/asm/LICENSE
    "MIT",      # ext/date/lib/LICENSE.rst

    # Extra licenses documented in README.REDIST.BINS ignoring unbundled pcre2lib (3) and gd (13)
    # ref: https://github.com/php/php-src/blob/PHP-8.4/README.REDIST.BINS
    "Apache-1.0",            # 10
    "Apache-2.0",            # 20
    "bcrypt-Solar-Designer", # 5
    "BSD-2-Clause-Darwin",   # 1
    "BSD-2-Clause",          # 14, 18, 19, 21; also TSRM/LICENSE
    "BSD-3-Clause",          # 4, 6, 11, 12, 15
    "BSD-4-Clause-UC",       # 9
    "ISC",                   # 10
    "LGPL-2.1-only",         # 2
    "LGPL-2.1-or-later",     # 16
    "OLDAP-2.8",             # 17
    "TCL",                   # 7
    "Zlib",                  # 8
  ]
  compatibility_version 1

  livecheck do
    url "https://www.php.net/downloads?source=Y"
    regex(/href=.*?php[._-]v?(#{Regexp.escape(version.major_minor)}(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "27f30b50fa33b7ae0394edec3b9977a3aa64683471d69e7098d013dad6a732f1"
    sha256 arm64_sequoia: "5f21fd835c0a44139333cb63e1f323f571dec5c0ce52966a9953513f540999ee"
    sha256 arm64_sonoma:  "5c3fd92fc76ed575c28aedfd2f7b67c93712a9e09b9507bf0e0b6619fa90d547"
    sha256 sonoma:        "48ce089cc5a42663cdb3bb82b7e73451236cd39fca11b122ec94284db3e68bf9"
    sha256 arm64_linux:   "8af3b6ab21208b07094b00cf9ce125dc94583661ddd2e68c6f346cbc9a5a578e"
    sha256 x86_64_linux:  "40e82572593a05a022ff5e520ba3dd64902c7dbdb2576a46bea234491a74226b"
  end

  keg_only :versioned_formula

  # Security Support Until 31 Dec 2028
  # https://www.php.net/supported-versions.php
  deprecate! date: "2028-12-31", because: :unsupported
  disable! date: "2029-12-31", because: :unsupported

  depends_on "httpd" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "apr"
  depends_on "apr-util"
  depends_on "argon2"
  depends_on "autoconf"
  depends_on "curl"
  depends_on "freetds"
  depends_on "gd"
  depends_on "gmp"
  depends_on "icu4c@78"
  depends_on "libpq"
  depends_on "libsodium"
  depends_on "libzip"
  depends_on "net-snmp"
  depends_on "oniguruma"
  depends_on "openldap"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "sqlite"
  depends_on "tidy-html5"
  depends_on "unixodbc"

  uses_from_macos "xz" => :build
  uses_from_macos "bzip2"
  uses_from_macos "libedit"
  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    inreplace "configure" do |s|
      s.gsub! "$APXS_HTTPD -V 2>/dev/null | grep 'threaded:.*yes' >/dev/null 2>&1",
              "false"
      s.gsub! "APXS_LIBEXECDIR='$(INSTALL_ROOT)'$($APXS -q LIBEXECDIR)",
              "APXS_LIBEXECDIR='$(INSTALL_ROOT)#{lib}/httpd/modules'"
      s.gsub! "-z $($APXS -q SYSCONFDIR)",
              "-z ''"

      # apxs will interpolate the @ in the versioned prefix: https://bz.apache.org/bugzilla/show_bug.cgi?id=61944
      s.gsub! "LIBEXECDIR='$APXS_LIBEXECDIR'",
              "LIBEXECDIR='" + "#{lib}/httpd/modules".gsub("\\", "\\\\").gsub("@", "\\@") + "'"
    end

    # Update error message in apache sapi to better explain the requirements
    # of using Apache http in combination with php if the non-compatible MPM
    # has been selected. Homebrew has chosen not to support being able to
    # compile a thread safe version of PHP and therefore it is not
    # possible to recompile as suggested in the original message
    inreplace "sapi/apache2handler/sapi_apache2.c",
              "You need to recompile PHP.",
              "Homebrew PHP does not support a thread-safe php binary. " \
              "To use the PHP apache sapi please change " \
              "your httpd config to use the prefork MPM"

    inreplace "sapi/fpm/php-fpm.conf.in", ";daemonize = yes", "daemonize = no"

    config_path = etc/"php/#{version.major_minor}"
    # Prevent system pear config from inhibiting pear install
    (config_path/"pear.conf").delete if (config_path/"pear.conf").exist?

    # Prevent homebrew from hardcoding path to sed shim in phpize script
    ENV["lt_cv_path_SED"] = "sed"

    # Identify build provider in php -v output and phpinfo()
    ENV["PHP_BUILD_PROVIDER"] = tap.user

    if OS.mac?
      sdk_path = MacOS.sdk_for_formula(self).path
      ENV["SASL_CFLAGS"] = "-I#{sdk_path}/usr/include/sasl"
      ENV["SASL_LIBS"] = "-lsasl2"

      # Each extension needs a direct reference to the sdk path or it won't find the headers
      headers_path = "=#{sdk_path}/usr"

      # PHP build system incorrectly links system libraries: https://github.com/php/php-src/issues/10680
      # Homebrew's superenv can only discard these if using realpath of SDK
      ENV["HOMEBREW_SDKROOT"] = sdk_path.realpath
    else
      ENV["SQLITE_CFLAGS"] = "-I#{formula_opt_include("sqlite")}"
      ENV["SQLITE_LIBS"] = "-lsqlite3"
      ENV["BZIP_DIR"] = formula_opt_prefix("bzip2")
    end

    # `_www` only exists on macOS.
    fpm_user = OS.mac? ? "_www" : "www-data"
    fpm_group = OS.mac? ? "_www" : "www-data"

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
      --enable-gd
      --enable-intl
      --enable-mbregex
      --enable-mbstring
      --enable-mysqlnd
      --enable-pcntl
      --enable-phpdbg
      --enable-phpdbg-readline
      --enable-shmop
      --enable-soap
      --enable-sockets
      --enable-sysvmsg
      --enable-sysvsem
      --enable-sysvshm
      --with-apxs2=#{formula_opt_bin("httpd")}/apxs
      --with-bz2#{headers_path}
      --with-curl
      --with-external-gd
      --with-external-pcre
      --with-ffi
      --with-fpm-user=#{fpm_user}
      --with-fpm-group=#{fpm_group}
      --with-gettext=#{formula_opt_prefix("gettext")}
      --with-gmp=#{formula_opt_prefix("gmp")}
      --with-iconv#{headers_path}
      --with-layout=GNU
      --with-ldap=#{formula_opt_prefix("openldap")}
      --with-libxml
      --with-libedit
      --with-mhash#{headers_path}
      --with-mysql-sock=/tmp/mysql.sock
      --with-mysqli=mysqlnd
      --with-ndbm#{headers_path}
      --with-openssl
      --with-password-argon2=#{formula_opt_prefix("argon2")}
      --with-pdo-dblib=#{formula_opt_prefix("freetds")}
      --with-pdo-mysql=mysqlnd
      --with-pdo-odbc=unixODBC,#{formula_opt_prefix("unixodbc")}
      --with-pdo-pgsql=#{formula_opt_prefix("libpq")}
      --with-pdo-sqlite
      --with-pgsql=#{formula_opt_prefix("libpq")}
      --with-pic
      --with-snmp=#{formula_opt_prefix("net-snmp")}
      --with-sodium
      --with-sqlite3
      --with-tidy=#{formula_opt_prefix("tidy-html5")}
      --with-unixODBC
      --with-xsl
      --with-zip
      --with-zlib
    ]

    if OS.mac?
      args << "--enable-dtrace"
      args << "--with-ldap-sasl"
    else
      args << "--disable-dtrace"
      args << "--without-ldap-sasl"
      args << "--without-ndbm"
      args << "--without-gdbm"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    # Allow pecl to install outside of Cellar
    extension_dir = Utils.safe_popen_read(bin/"php-config", "--extension-dir").chomp
    orig_ext_dir = File.basename(extension_dir)
    inreplace bin/"php-config", lib/"php", prefix/"pecl"

    openssl = Formula["openssl@3"]
    %w[development production].each do |mode|
      inreplace "php.ini-#{mode}" do |s|
        # Allow pecl to install outside of Cellar
        s.gsub! %r{; ?extension_dir = "\./"}, "extension_dir = \"#{HOMEBREW_PREFIX}/lib/php/pecl/#{orig_ext_dir}\""

        # Use OpenSSL cert bundle
        s.gsub!(/; ?openssl\.cafile=/, "openssl.cafile = \"#{openssl.pkgetc}/cert.pem\"")
        s.gsub!(/; ?openssl\.capath=/, "openssl.capath = \"#{openssl.pkgetc}/certs\"")
      end
    end

    config_files = {
      "php.ini-development"   => "php.ini",
      "php.ini-production"    => "php.ini-production",
      "sapi/fpm/php-fpm.conf" => "php-fpm.conf",
      "sapi/fpm/www.conf"     => "php-fpm.d/www.conf",
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

  post_install_steps do
    configure_php
  end

  def caveats
    <<~EOS
      To enable PHP in Apache add the following to httpd.conf and restart Apache:
          LoadModule php_module #{opt_lib}/httpd/modules/libphp.so

          <FilesMatch \\.php$>
              SetHandler application/x-httpd-php
          </FilesMatch>

      Finally, check DirectoryIndex includes index.php
          DirectoryIndex index.php index.html

      The php.ini and php-fpm.ini file can be found in:
          #{etc}/php/#{version.major_minor}/
    EOS
  end

  service do
    run [opt_sbin/"php-fpm", "--nodaemonize"]
    run_type :immediate
    keep_alive true
    error_log_path var/"log/php-fpm.log"
    working_dir var
  end

  test do
    assert_match(/^Zend OPcache$/, shell_output("#{bin}/php -i"), "Zend OPCache extension not loaded")

    # Test related to libxml2 and https://github.com/Homebrew/homebrew-core/issues/28398
    require "utils/linkage"
    libpq = formula_opt_lib("libpq")/shared_library("libpq")
    assert Utils.binary_linked_to_library?(bin/"php", libpq), "No linkage with Homebrew #{libpq.basename}!"

    system sbin/"php-fpm", "-t"
    system bin/"phpdbg", "-V"
    system bin/"php-cgi", "-m"

    (testpath/"test.php").write <<~PHP
      <?php
      $formatter = new NumberFormatter('en_US', NumberFormatter::DECIMAL);
      echo $formatter->format(1234567), PHP_EOL;

      $formatter = new MessageFormatter('de_DE', '{0,number,#,###.##} MB');
      echo $formatter->format([12345.6789]);
      ?>
    PHP
    assert_equal "1,234,567\n12.345,68 MB", shell_output("#{bin}/php test.php")

    port = free_port
    port_fpm = free_port
    expected_output = /^Hello world!$/

    (testpath/"index.php").write <<~PHP
      <?php
      echo 'Hello world!' . PHP_EOL;
      var_dump(ldap_connect());
      $session = new SNMP(SNMP::VERSION_1, '127.0.0.1', 'public');
      var_dump(@$session->get('sysDescr.0'));
    PHP

    main_config = <<~EOS
      Listen #{port}
      ServerName localhost:#{port}
      DocumentRoot "#{testpath}"
      ErrorLog "#{testpath}/httpd-error.log"
      ServerRoot "#{formula_opt_prefix("httpd")}"
      PidFile "#{testpath}/httpd.pid"
      LoadModule authz_core_module lib/httpd/modules/mod_authz_core.so
      LoadModule unixd_module lib/httpd/modules/mod_unixd.so
      LoadModule dir_module lib/httpd/modules/mod_dir.so
      DirectoryIndex index.php
    EOS

    (testpath/"httpd.conf").write <<~EOS
      #{main_config}
      LoadModule mpm_prefork_module lib/httpd/modules/mod_mpm_prefork.so
      LoadModule php_module #{lib}/httpd/modules/libphp.so
      <FilesMatch \\.(php|phar)$>
        SetHandler application/x-httpd-php
      </FilesMatch>
    EOS

    (testpath/"fpm.conf").write <<~INI
      [global]
      daemonize=no
      [www]
      listen = 127.0.0.1:#{port_fpm}
      pm = dynamic
      pm.max_children = 5
      pm.start_servers = 2
      pm.min_spare_servers = 1
      pm.max_spare_servers = 3
    INI

    (testpath/"httpd-fpm.conf").write <<~EOS
      #{main_config}
      LoadModule mpm_event_module lib/httpd/modules/mod_mpm_event.so
      LoadModule proxy_module lib/httpd/modules/mod_proxy.so
      LoadModule proxy_fcgi_module lib/httpd/modules/mod_proxy_fcgi.so
      <FilesMatch \\.(php|phar)$>
        SetHandler "proxy:fcgi://127.0.0.1:#{port_fpm}"
      </FilesMatch>
    EOS

    begin
      pid = spawn formula_opt_bin("httpd")/"httpd", "-X", "-f", testpath/"httpd.conf"
      sleep 10
      assert_match expected_output, shell_output("curl -s 127.0.0.1:#{port}")

      Process.kill("TERM", pid)
      Process.wait(pid)

      fpm_pid = spawn sbin/"php-fpm", "-y", "fpm.conf"
      pid = spawn formula_opt_bin("httpd")/"httpd", "-X", "-f", testpath/"httpd-fpm.conf"
      sleep 10
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
