class Php < Formula
  desc "General-purpose scripting language"
  homepage "https://www.php.net/"
  # Should only be updated if the new version is announced on the homepage, https://www.php.net/
  # TODO: Remove TAILCALL VM workaround in next release
  url "https://www.php.net/distributions/php-8.5.0.tar.xz"
  mirror "https://fossies.org/linux/www/php-8.5.0.tar.xz"
  sha256 "39cb6e4acd679b574d3d3276f148213e935fc25f90403eb84fb1b836a806ef1e"
  license all_of: [
    "PHP-3.01",

    # Extra licenses not documented in README.REDIST.BINS
    "Zend-2.0", # Zend/LICENSE
    "BSL-1.0",  # Zend/asm/LICENSE
    "MIT",      # ext/date/lib/LICENSE.rst

    # Extra licenses documented in README.REDIST.BINS ignoring unbundled pcre2lib (3) and gd (13)
    # ref: https://github.com/php/php-src/blob/PHP-8.5/README.REDIST.BINS
    "Apache-1.0",            # 10
    "Apache-2.0",            # 20
    "bcrypt-Solar-Designer", # 5
    "BSD-2-Clause-Darwin",   # 1
    "BSD-2-Clause",          # 14, 18, 19, 21; also TSRM/LICENSE
    "BSD-3-Clause",          # 4, 6, 11, 12, 15, 22
    "BSD-4-Clause-UC",       # 9
    "ISC",                   # 10
    "LGPL-2.1-only",         # 2
    "LGPL-2.1-or-later",     # 16
    "OLDAP-2.8",             # 17
    "TCL",                   # 7
    "Zlib",                  # 8
  ]

  livecheck do
    url "https://www.php.net/downloads?source=Y"
    regex(/href=.*?php[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "03b97964f87cb37c098baf62b9f169d2eba6d884f4081c66aff692f56bec9812"
    sha256 arm64_sequoia: "451d75733fba64fb6e84a28333bb2b02ec83dd14137bc83c8473a26b83344829"
    sha256 arm64_sonoma:  "4fe86395bd69087c9813c861d569f40bea798f2d5eb889f231013f31ee471c2c"
    sha256 sonoma:        "802c83d269609153296be37dbcb14373d3d9589c1d158aeaa67218dcf9c3e3e3"
    sha256 arm64_linux:   "f22af7b3c6b3dc169f8b44a7d21e53b0c677785cb5d0ae22dbffa30f08353cf9"
    sha256 x86_64_linux:  "d5d380cdeefea8b7d1a264f9bff9d0cf867aae9effcf0491913de1cf4a12b99f"
  end

  head do
    url "https://github.com/php/php-src.git", branch: "master"

    depends_on "bison" => :build # bison >= 3.0.0 required to generate parsers
    depends_on "re2c" => :build # required to generate PHP lexers
  end

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

  uses_from_macos "cyrus-sasl" => :build
  uses_from_macos "bzip2"
  uses_from_macos "libedit"
  uses_from_macos "libffi"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./buildconf", "--force" if build.head?

    inreplace "configure" do |s|
      s.gsub! "$APXS_HTTPD -V 2>/dev/null | grep 'threaded:.*yes' >/dev/null 2>&1",
              "false"
      s.gsub! "APXS_LIBEXECDIR='$(INSTALL_ROOT)'$($APXS -q LIBEXECDIR)",
              "APXS_LIBEXECDIR='$(INSTALL_ROOT)#{lib}/httpd/modules'"
      s.gsub! "-z $($APXS -q SYSCONFDIR)",
              "-z ''"

      # Workaround to enable TAILCALL VM, issue ref: https://github.com/php/php-src/issues/20546
      s.gsub!(/("(?:call|bl)\s+)(fun\\n")/, "\\1_\\2") if OS.mac? && build.stable?

      # NOTE: `versioned_formula?` conditionals are to make sure correct changes
      # are applied if copied from `php`. Remove dead code when creating `php@x.y`
      if versioned_formula?
        # apxs will interpolate the @ in the versioned prefix: https://bz.apache.org/bugzilla/show_bug.cgi?id=61944
        s.gsub! "LIBEXECDIR='$APXS_LIBEXECDIR'",
                "LIBEXECDIR='" + "#{lib}/httpd/modules".gsub("\\", "\\\\").gsub("@", "\\@") + "'"
      end
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

    # Identify build provider in php -v output and phpinfo()
    ENV["PHP_BUILD_PROVIDER"] = tap.user

    if OS.mac?
      sdk_path = MacOS.sdk_for_formula(self).path
      ENV["SASL_CFLAGS"] = "-I#{sdk_path}/usr/include/sasl"
      ENV["SASL_LIBS"] = "-lsasl2"

      # Each extension needs a direct reference to the sdk path or it won't find the headers
      headers_path = "=#{sdk_path}/usr"
      gettext_path = "=#{Formula["gettext"].opt_prefix}"
    else
      ENV["BZIP_DIR"] = Formula["bzip2"].opt_prefix
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
      --disable-intl
      --enable-bcmath
      --enable-calendar
      --enable-dba
      --enable-exif
      --enable-ftp
      --enable-fpm
      --enable-gd
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
      --with-apxs2=#{Formula["httpd"].opt_bin}/apxs
      --with-bz2#{headers_path}
      --with-curl
      --with-external-gd
      --with-external-pcre
      --with-ffi
      --with-fpm-user=#{fpm_user}
      --with-fpm-group=#{fpm_group}
      --with-gettext#{gettext_path}
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-iconv#{headers_path}
      --with-layout=GNU
      --with-ldap-sasl
      --with-ldap=#{Formula["openldap"].opt_prefix}
      --with-libedit
      --with-libxml
      --with-mhash#{headers_path}
      --with-mysql-sock=/tmp/mysql.sock
      --with-mysqli=mysqlnd
      --with-ndbm#{headers_path}
      --with-openssl
      --with-password-argon2=#{Formula["argon2"].opt_prefix}
      --with-pdo-dblib=#{Formula["freetds"].opt_prefix}
      --with-pdo-mysql=mysqlnd
      --with-pdo-odbc=unixODBC,#{Formula["unixodbc"].opt_prefix}
      --with-pdo-pgsql=#{Formula["libpq"].opt_prefix}
      --with-pdo-sqlite
      --with-pgsql=#{Formula["libpq"].opt_prefix}
      --with-pic
      --with-snmp=#{Formula["net-snmp"].opt_prefix}
      --with-sodium
      --with-sqlite3
      --with-tidy=#{Formula["tidy-html5"].opt_prefix}
      --with-unixODBC
      --with-xsl
      --with-zip
      --with-zlib
    ]

    if OS.mac?
      args << "--enable-dtrace"
    else
      args << "--disable-dtrace"
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
    inreplace ["php.ini-development", "php.ini-production"] do |s|
      s.gsub! %r{; ?extension_dir = "\./"}, "extension_dir = \"#{HOMEBREW_PREFIX}/lib/php/pecl/#{orig_ext_dir}\""

      # Use OpenSSL cert bundle
      openssl = Formula["openssl@3"]
      s.gsub!(/; ?openssl\.cafile=/, "openssl.cafile = \"#{openssl.pkgetc}/cert.pem\"")
      s.gsub!(/; ?openssl\.capath=/, "openssl.capath = \"#{openssl.pkgetc}/certs\"")
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
    pecl_path.mkpath
    ln_s pecl_path, prefix/"pecl" unless (prefix/"pecl").exist?
    extension_dir = Utils.safe_popen_read(bin/"php-config", "--extension-dir").chomp
    php_basename = File.basename(extension_dir)
    (pecl_path/php_basename).mkpath

    # fix pear config to install outside cellar
    pear_dir = versioned_formula? ? "pear@#{version.major_minor}" : "pear"
    pear_path = HOMEBREW_PREFIX/"share"/pear_dir
    cp_r pkgshare/"pear/.", pear_path
    {
      "php_ini"  => etc/"php/#{version.major_minor}/php.ini",
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
      value.mkpath if /(?<!bin|man)_dir$/.match?(key)
      system bin/"pear", "config-set", key, value, "system"
    end

    system bin/"pear", "update-channels"
  end

  def caveats
    <<~EOS
      The PHP Internationalization extension is now in the `php-intl` formula.

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
    libpq = Formula["libpq"].opt_lib/shared_library("libpq")
    assert Utils.binary_linked_to_library?(bin/"php", libpq), "No linkage with Homebrew #{libpq.basename}!"

    system sbin/"php-fpm", "-t"
    system bin/"phpdbg", "-V"
    system bin/"php-cgi", "-m"

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
      pid = spawn Formula["httpd"].opt_bin/"httpd", "-X", "-f", "#{testpath}/httpd.conf"
      sleep 10
      assert_match expected_output, shell_output("curl -s 127.0.0.1:#{port}")

      Process.kill("TERM", pid)
      Process.wait(pid)

      fpm_pid = spawn sbin/"php-fpm", "-y", "fpm.conf"
      pid = spawn Formula["httpd"].opt_bin/"httpd", "-X", "-f", "#{testpath}/httpd-fpm.conf"
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
