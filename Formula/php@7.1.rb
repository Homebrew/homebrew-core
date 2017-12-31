class PhpAT71 < Formula
  desc "General-purpose scripting language"
  homepage "https://secure.php.net/"
  url "https://php.net/get/php-7.1.12.tar.xz/from/this/mirror"
  sha256 "a0118850774571b1f2d4e30b4fe7a4b958ca66f07d07d65ebdc789c54ba6eeb3"

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "aspell"
  depends_on "berkeley-db@4"
  depends_on "curl" if MacOS.version < :lion
  depends_on "freetds"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gmp"
  depends_on "httpd"
  depends_on "icu4c"
  depends_on "imap-uw"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libzip"
  depends_on "mcrypt"
  depends_on "net-snmp"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "unixodbc"
  depends_on "webp"

  resource "enchant" do
    url "https://www.abisource.com/downloads/enchant/1.6.0/enchant-1.6.0.tar.gz"
    sha256 "2fac9e7be7e9424b2c5570d8affe568db39f7572c10ed48d4e13cddf03f7097f"
  end

  needs :cxx11

  def install
    if MacOS.version == :el_capitan || MacOS.version == :sierra
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    inreplace "configure",
              "APACHE_THREADED_MPM=`$APXS_HTTPD -V | grep 'threaded:.*yes'`",
              "APACHE_THREADED_MPM="

    inreplace "sapi/apache2handler/sapi_apache2.c",
              "You need to recompile PHP.",
              "Homebrew PHP does not support a thread-safe php binary. "\
              "To use the PHP apache sapi please change "\
              "your httpd config to use the prefork MPM"

    ENV.cxx11

    config_path = etc/"php/#{php_version}"
    ENV["lt_cv_path_SED"] = "sed"

    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{config_path}
      --with-config-file-path=#{config_path}
      --with-config-file-scan-dir=#{config_path}/conf.d
      --with-layout=GNU
      --enable-bcmath=shared
      --enable-calendar=shared
      --enable-ctype=shared
      --enable-dba=shared
      --enable-dom=shared
      --enable-dtrace
      --enable-exif=shared
      --enable-fileinfo=shared
      --enable-ftp=shared
      --enable-fpm
      --enable-gd-native-ttf
      --enable-intl=shared
      --enable-json=shared
      --enable-mbregex
      --enable-mbstring=shared
      --enable-mysqlnd=shared
      --enable-opcache-file
      --enable-pcntl
      --enable-phpdbg
      --enable-phpdbg-webhelper
      --enable-posix=shared
      --enable-shmop=shared
      --enable-simplexml=shared
      --enable-soap=shared
      --enable-sockets=shared
      --enable-sysvmsg=shared
      --enable-sysvsem=shared
      --enable-sysvshm=shared
      --enable-tokenizer=shared
      --enable-wddx=shared
      --enable-xmlreader=shared
      --enable-xmlwriter=shared
      --enable-zip=shared
      --with-apxs2=#{Formula["httpd"].opt_bin}/apxs
      --with-bz2=shared
      --with-db4=#{Formula["berkeley-db@4"].opt_prefix}
      --with-enchant=shared,#{prefix}/vendor
      --with-fpm-user=_www
      --with-fpm-group=_www
      --with-freetype-dir=#{Formula["freetype"].opt_prefix}
      --with-gd=shared
      --with-gettext=shared,#{Formula["gettext"].opt_prefix}
      --with-gmp=shared,#{Formula["gmp"].opt_prefix}
      --with-iconv=shared
      --with-icu-dir=#{Formula["icu4c"].opt_prefix}
      --with-imap=shared,#{Formula["imap-uw"].opt_prefix}
      --with-imap-ssl=#{Formula["openssl"].opt_prefix}
      --with-jpeg-dir=#{Formula["jpeg"].opt_prefix}
      --with-kerberos
      --with-ldap=shared
      --with-ldap-sasl
      --with-libedit
      --with-libzip
      --with-mcrypt=shared,#{Formula["mcrypt"].opt_prefix}
      --with-mhash
      --with-mysql-sock=/tmp/mysql.sock
      --with-mysqli=shared,mysqlnd
      --with-ndbm
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --with-openssl-dir=#{Formula["openssl"].opt_prefix}
      --with-pdo-dblib=shared,#{Formula["freetds"].opt_prefix}
      --with-pdo-mysql=shared,mysqlnd
      --with-pdo-odbc=shared,unixODBC,#{Formula["unixodbc"].opt_prefix}
      --with-pdo-pgsql=shared,#{Formula["libpq"].opt_prefix}
      --with-pdo-sqlite=shared
      --with-pgsql=shared,#{Formula["libpq"].opt_prefix}
      --with-pic
      --with-png-dir=#{Formula["libpng"].opt_prefix}
      --with-pspell=shared,#{Formula["aspell"].opt_prefix}
      --with-snmp=shared
      --with-sqlite3=shared
      --with-tidy=shared
      --with-unixODBC=shared,#{Formula["unixodbc"].opt_prefix}
      --with-webp-dir=#{Formula["webp"].opt_prefix}
      --with-xmlrpc=shared
      --with-xsl=shared
      --with-zlib
    ]

    arg = "--with-curl=shared"
    arg << ",#{Formula["curl"].opt_prefix}" if MacOS.version < :lion
    args << arg

    resource("enchant").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}/vendor",
                            "--disable-ispell",
                            "--disable-myspell"
      system "make", "install"
    end

    system "./configure", *args

    # apxs will interpolate the @ in the versioned prefix: https://bz.apache.org/bugzilla/show_bug.cgi?id=61944
    apxs_lib = "#{lib}/httpd/modules"
    apxs_safe_lib = apxs_lib.gsub "@", "\\@"

    # Custom location for php module and remove -a (don't touch httpd.conf)
    inreplace "Makefile",
      /^INSTALL_IT = \$\(mkinstalldirs\) '([^']+)' (.+) LIBEXECDIR=([^\s]+) (.+) -a (.+)$/,
      "INSTALL_IT = $(mkinstalldirs) '#{apxs_lib}' \\2 LIBEXECDIR='#{apxs_safe_lib}' \\4 \\5"

    system "make"
    system "make", "install"

    orig_ext_dir = File.basename `#{bin}/php-config --extension-dir`.chomp
    inreplace bin/"php-config", lib/"php", prefix/"pecl-extensions"
    inreplace "php.ini-development", %r{^; extension_dir = "\./"},
      "extension_dir = \"#{HOMEBREW_PREFIX}/lib/php/#{php_version}/#{orig_ext_dir}\""

    config_path.install "php.ini-development" => "php.ini"
    (config_path/"php-fpm.d").install "sapi/fpm/www.conf"
    config_path.install "sapi/fpm/php-fpm.conf"
    inreplace config_path/"php-fpm.conf", /^;?daemonize\s*=.+$/, "daemonize = no"

    unless File.exist? "#{var}/log/php-fpm.log"
      (var/"log").mkpath
      touch var/"log/php-fpm.log"
    end
  end

  def caveats
    s = []

    s << <<-EOS.undent
      To enable PHP in Apache add the following to httpd.conf and restart Apache:
          LoadModule php7_module #{opt_lib}/httpd/modules/libphp7.so

          <FilesMatch \.php$>
              SetHandler application/x-httpd-php
          </FilesMatch>

      Finally, check DirectoryIndex includes index.php
          DirectoryIndex index.php index.html
    EOS

    s << <<-EOS.undent
      The php.ini and php-fpm.ini file can be found in:
          #{etc}/php/#{php_version}/

      The snmp extension is disabled by default since it crashes when used with the Apache SAPI.
    EOS

    s.join "\n"
  end

  def post_install
    pear_prefix = share/"pear"
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

    # custom location for extensions installed via pecl
    pecl_path = HOMEBREW_PREFIX/"lib/php"/php_version
    pecl_path.mkpath
    ln_s pecl_path, prefix/"pecl-extensions" unless (prefix/"pecl-extensions").exist?
    php_basename = File.basename `#{bin}/php-config --extension-dir`.chomp
    php_ext_dir = opt_prefix/"lib/php"/php_basename

    # fix pear config to install outside cellar
    pear_path = HOMEBREW_PREFIX/"share/pear"
    {
      "php_ini" => etc/"php/#{php_version}/php.ini",
      "php_dir" => pear_path,
      "doc_dir" => pear_path/"doc",
      "ext_dir" => pecl_path/php_basename,
      "bin_dir" => opt_bin,
      "data_dir" => pear_path/"data",
      "cfg_dir" => pear_path/"cfg",
      "www_dir" => pear_path/"htdocs",
      "man_dir" => HOMEBREW_PREFIX/"share/man",
      "test_dir" => pear_path/"test",
      "php_bin" => opt_bin/"php",
    }.each do |key, value|
      value.mkpath if key =~ /(?<!bin|man)_dir$/
      system bin/"pear", "config-set", key, value, "system"
    end

    %w[
      bcmath
      bz2
      calendar
      ctype
      curl
      dba
      dom
      enchant
      exif
      fileinfo
      ftp
      gd
      gettext
      gmp
      iconv
      imap
      intl
      json
      ldap
      mbstring
      mcrypt
      mysqli
      mysqlnd
      opcache
      pdo_dblib
      pdo_mysql
      pdo_odbc
      pdo_pgsql
      pdo_sqlite
      pgsql
      posix
      pspell
      shmop
      simplexml
      snmp
      soap
      sockets
      sqlite3
      sysvmsg
      sysvsem
      sysvshm
      tidy
      tokenizer
      wddx
      xmlreader
      xmlrpc
      xmlwriter
      xsl
      zip
    ].each do |e|
      ini_priority = case e
      when "opcache" then "10"
      when /pdo_|mysqli|wddx|xmlreader|xmlrpc/ then "30"
      else "20"
      end
      ext_config_path = etc/"php/#{php_version}/conf.d/#{ini_priority}-ext-#{e}.ini"
      extension_type = (e == "opcache") ? "zend_extension" : "extension"
      if ext_config_path.exist?
        inreplace ext_config_path,
          /#{extension_type}=.*$/, "#{extension_type}=#{php_ext_dir}/#{e}.so"
      else
        # Do not load snmp extension by default
        extension_type.prepend("#") if e == "snmp"
        ext_config_path.write <<-EOS.undent
          [#{e}]
          #{extension_type}="#{php_ext_dir}/#{e}.so"
        EOS
      end
    end
  end

  def php_version
    version.to_s.split(".")[0..1].join(".")
  end

  plist_options :startup => true, :manual => "php-fpm"

  def plist; <<-EOPLIST.undent
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
    EOPLIST
  end

  test do
    system "#{bin}/php", "-i"
    system "#{sbin}/php-fpm", "-t"
    system "#{bin}/phpdbg", "-V"
    system "#{bin}/php-cgi", "-m"
    begin
      expected_output = /^Hello world!$/
      (testpath/"index.php").write <<~EOS
        <?php
        echo 'Hello world!';
      EOS
      main_config = <<~EOS
        Listen 8585
        ServerName localhost:8585
        DocumentRoot "#{testpath}"
        ErrorLog "#{testpath}/httpd-error.log"
        ServerRoot "#{Formula["httpd"].opt_prefix}"
        LoadModule authz_core_module lib/httpd/modules/mod_authz_core.so
        LoadModule unixd_module lib/httpd/modules/mod_unixd.so
        LoadModule dir_module lib/httpd/modules/mod_dir.so
        DirectoryIndex index.php
      EOS

      (testpath/"httpd.conf").write <<~EOS
        #{main_config}
        LoadModule mpm_prefork_module lib/httpd/modules/mod_mpm_prefork.so
        LoadModule php7_module #{lib}/httpd/modules/libphp7.so
        <FilesMatch \.(php|phar)$>
          SetHandler application/x-httpd-php
        </FilesMatch>
      EOS

      (testpath/"httpd-fpm.conf").write <<~EOS
        #{main_config}
        LoadModule mpm_event_module lib/httpd/modules/mod_mpm_event.so
        LoadModule proxy_module lib/httpd/modules/mod_proxy.so
        LoadModule proxy_fcgi_module lib/httpd/modules/mod_proxy_fcgi.so
        <FilesMatch \.(php|phar)$>
          SetHandler "proxy:fcgi://127.0.0.1:9000"
        </FilesMatch>
      EOS

      pid = fork do
        exec Formula["httpd"].opt_bin/"httpd", "-X", "-f", "#{testpath}/httpd.conf"
      end
      sleep 3

      assert_match expected_output, shell_output("curl -s 127.0.0.1:8585")

      Process.kill("TERM", pid)
      Process.wait(pid)
      pid = nil

      fpm_pid = fork do
        exec sbin/"php-fpm"
      end
      pid = fork do
        exec Formula["httpd"].opt_bin/"httpd", "-X", "-f", "#{testpath}/httpd-fpm.conf"
      end
      sleep 3

      assert_match expected_output, shell_output("curl -s 127.0.0.1:8585")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
      if fpm_pid
        Process.kill("TERM", fpm_pid)
        Process.wait(fpm_pid)
      end
    end
  end
end
