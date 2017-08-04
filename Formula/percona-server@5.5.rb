class PerconaServerAT55 < Formula
  desc "Drop-in MySQL replacement"
  homepage "https://www.percona.com/"
  url "https://www.percona.com/downloads/Percona-Server-5.5/Percona-Server-5.5.55-38.8/source/tarball/percona-server-5.5.55-38.8.tar.gz"
  version "5.5.55-38.8"
  sha256 "7db7a012c2792457e8bbc1aa42ddf40bfe2fabbb1db0e11905654a4a2861403e"

  bottle do
    sha256 "329a8c6dbb48d649dac49a905d853f2f9a2cdfa8440fd984e36943814c1b783f" => :sierra
    sha256 "f30c7af13748fdca4ba60c93725ce27a8f95130810aa243735abc9fb99c00554" => :el_capitan
    sha256 "44be85e1f6c64b5cd996245325b87166ec7ead7e8927173188b3eb79e96d30e9" => :yosemite
  end

  keg_only :versioned_formula

  option "with-test", "Build with unit tests"
  option "with-embedded", "Build the embedded server"
  option "with-libedit", "Compile with editline wrapper instead of readline"
  option "with-local-infile", "Build with local infile loading support"

  deprecated_option "enable-local-infile" => "with-local-infile"
  deprecated_option "with-tests" => "with-test"

  depends_on "cmake" => :build
  depends_on "readline"
  depends_on "pidof"
  depends_on "openssl"

  # Where the database files should be located. Existing installs have them
  # under var/percona, but going forward they will be under var/mysql to be
  # shared with the mysql and mariadb formulae.
  def datadir
    @datadir ||= (var/"percona").directory? ? var/"percona" : var/"mysql"
  end

  pour_bottle? do
    reason "The bottle needs a var/mysql datadir (yours is var/percona)."
    satisfy { datadir == var/"mysql" }
  end

  def install
    args = std_cmake_args + %W[
      -DMYSQL_DATADIR=#{datadir}
      -DSYSCONFDIR=#{etc}
      -DINSTALL_MANDIR=#{man}
      -DINSTALL_DOCDIR=#{doc}
      -DINSTALL_INFODIR=#{info}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_MYSQLSHAREDIR=#{share.basename}/mysql
      -DWITH_SSL=yes
      -DDEFAULT_CHARSET=utf8
      -DDEFAULT_COLLATION=utf8_general_ci
      -DCOMPILATION_COMMENT=Homebrew
      -DWITH_EDITLINE=system
    ]

    # PAM plugin is Linux-only at the moment
    args.concat %w[
      -DWITHOUT_AUTH_PAM=1
      -DWITHOUT_AUTH_PAM_COMPAT=1
      -DWITHOUT_DIALOG=1
    ]

    # To enable unit testing at build, we need to download the unit testing suite
    if build.with? "tests"
      args << "-DENABLE_DOWNLOADS=ON"
    else
      args << "-DWITH_UNIT_TESTS=OFF"
    end

    # Build the embedded server
    args << "-DWITH_EMBEDDED_SERVER=ON" if build.with? "embedded"

    # Compile with readline unless libedit is explicitly chosen
    args << "-DWITH_READLINE=yes" if build.without? "libedit"

    # Build with local infile loading support
    args << "-DENABLED_LOCAL_INFILE=1" if build.include? "enable-local-infile"

    system "cmake", *args
    system "make"
    system "make", "install"

    # Don't create databases inside of the prefix!
    # See: https://github.com/mxcl/homebrew/issues/4975
    rm_rf prefix+"data"

    # Link the setup script into bin
    ln_s prefix+"scripts/mysql_install_db", bin+"mysql_install_db"

    # Fix up the control script and link into bin
    inreplace "#{prefix}/support-files/mysql.server",
      /^(PATH=".*)(")/, "\\1:#{HOMEBREW_PREFIX}/bin\\2"

    ln_s "#{prefix}/support-files/mysql.server", bin

    # Move mysqlaccess to libexec
    libexec.mkpath
    mv "#{bin}/mysqlaccess", libexec
    mv "#{bin}/mysqlaccess.conf", libexec

    # Install my.cnf that binds to 127.0.0.1 by default
    (buildpath/"my.cnf").write <<-EOS.undent
      # Default Homebrew MySQL server config
      [mysqld]
      # Only allow connections from localhost
      bind-address = 127.0.0.1
    EOS
    etc.install "my.cnf"
  end

  def caveats; <<-EOS.undent
    Set up databases to run AS YOUR USER ACCOUNT with:
        unset TMPDIR
        mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix percona-server55)" --datadir=#{datadir} --tmpdir=/tmp

    To set up base tables in another folder, or use a different user to run
    mysqld, view the help for mysqld_install_db:
        mysql_install_db --help

    and view the MySQL documentation:
      * https://dev.mysql.com/doc/refman/5.5/en/mysql-install-db.html
      * https://dev.mysql.com/doc/refman/5.5/en/default-privileges.html

    To run as, for instance, user "mysql", you may need to `sudo`:
        sudo mysql_install_db ...options...

    A "/etc/my.cnf" from another install may interfere with a Homebrew-built
    server starting up correctly.

    MySQL is configured to only allow connections from localhost by default

    To connect:
        mysql -uroot
    EOS
  end

  plist_options :manual => "mysql.server start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>Program</key>
      <string>#{opt_prefix}/bin/mysqld_safe</string>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system "/bin/sh", "-n", "#{bin}/mysqld_safe"
    (prefix/"mysql-test").cd do
      system "./mysql-test-run.pl", "status", "--vardir=#{testpath}"
    end
  end
end
