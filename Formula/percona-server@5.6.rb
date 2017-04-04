class PerconaServerAT56 < Formula
  desc "Drop-in MySQL replacement"
  homepage "https://www.percona.com"
  url "https://www.percona.com/downloads/Percona-Server-5.6/Percona-Server-5.6.35-81.0/source/tarball/percona-server-5.6.35-81.0.tar.gz"
  version "5.6.35-81.0"
  sha256 "c71c3f80662982ade22a0a538c5fd595b1761472c98efc2509124ecc4004d1e7"

  bottle do
    sha256 "2baa1f237c534c5b088a63a50658aae0cda1e98bda7b8dbac18d4df226af27c5" => :sierra
    sha256 "92ac77c2779325e14a03237e2aaa66c6367937a0f7226df05053d9dce50ec943" => :el_capitan
    sha256 "c301571bb6c86b0e9ca0830a66a063a70d8b3a66d470379b251addcbce606385" => :yosemite
  end

  keg_only :versioned_formula

  option "with-test", "Build with unit tests"
  option "with-embedded", "Build the embedded server"
  option "with-memcached", "Build with InnoDB Memcached plugin"
  option "with-local-infile", "Build with local infile loading support"

  depends_on "cmake" => :build
  depends_on "pidof" unless MacOS.version >= :mountain_lion
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
    # Don't hard-code the libtool path. See:
    # https://github.com/Homebrew/homebrew/issues/20185
    inreplace "cmake/libutils.cmake",
      "COMMAND /usr/bin/libtool -static -o ${TARGET_LOCATION}",
      "COMMAND libtool -static -o ${TARGET_LOCATION}"

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
      -DCMAKE_FIND_FRAMEWORK=LAST
      -DCMAKE_VERBOSE_MAKEFILE=ON
    ]

    # PAM plugin is Linux-only at the moment
    args.concat %w[
      -DWITHOUT_AUTH_PAM=1
      -DWITHOUT_AUTH_PAM_COMPAT=1
      -DWITHOUT_DIALOG=1
    ]

    # TokuDB is broken on MacOsX
    # https://bugs.launchpad.net/percona-server/+bug/1531446
    args.concat %w[-DWITHOUT_TOKUDB=1]

    # To enable unit testing at build, we need to download the unit testing suite
    if build.with? "test"
      args << "-DENABLE_DOWNLOADS=ON"
    else
      args << "-DWITH_UNIT_TESTS=OFF"
    end

    # Build the embedded server
    args << "-DWITH_EMBEDDED_SERVER=ON" if build.with? "embedded"

    # Build with InnoDB Memcached plugin
    args << "-DWITH_INNODB_MEMCACHED=ON" if build.with? "memcached"

    # Make universal for binding to universal applications
    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    # Build with local infile loading support
    args << "-DENABLED_LOCAL_INFILE=1" if build.with? "local-infile"

    system "cmake", ".", *std_cmake_args, *args
    system "make"
    system "make", "install"

    # Don't create databases inside of the prefix!
    # See: https://github.com/Homebrew/homebrew/issues/4975
    rm_rf prefix+"data"

    # Link the setup script into bin
    bin.install_symlink prefix/"scripts/mysql_install_db"

    # Fix up the control script and link into bin
    inreplace "#{prefix}/support-files/mysql.server" do |s|
      s.gsub!(/^(PATH=".*)(")/, "\\1:#{HOMEBREW_PREFIX}/bin\\2")
      # pidof can be replaced with pgrep from proctools on Mountain Lion
      s.gsub!(/pidof/, "pgrep") if MacOS.version >= :mountain_lion
    end

    bin.install_symlink prefix/"support-files/mysql.server"

    # mysqlaccess deprecated on 5.6.17, and removed in 5.7.4.
    # See: https://bugs.mysql.com/bug.php?id=69012
    # Move mysqlaccess to libexec
    libexec.mkpath
    mv "#{bin}/mysqlaccess", libexec
    mv "#{bin}/mysqlaccess.conf", libexec
  end

  def post_install
    # Make sure that data directory exists
    datadir.mkpath
    unless File.exist? "#{datadir}/mysql/user.frm"
      ENV["TMPDIR"] = nil
      system "#{bin}/mysql_install_db", "--verbose", "--user=#{ENV["USER"]}",
        "--basedir=#{prefix}", "--datadir=#{datadir}", "--tmpdir=/tmp"
    end
  end

  def caveats; <<-EOS.undent
    A "/etc/my.cnf" from another install may interfere with a Homebrew-built
    server starting up correctly.

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
      <string>#{opt_bin}/mysqld_safe</string>
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
