class MysqlCluster < Formula
  desc "Shared-nothing clustering and auto-sharding for MySQL"
  homepage "https://www.mysql.com/products/cluster/"
  url "https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.5/mysql-cluster-gpl-7.5.6.tar.gz"
  sha256 "f799932e0baeb4cf61d735b662ebefba6d2d7b156cb66fc81c1bef4a4a43848d"

  bottle do
    rebuild 1
    sha256 "3eec1779c488fed8866ce5648c46fb76747b9028d41db67d1d56117e6497737a" => :sierra
    sha256 "ea45e531c06a0e6aa7c3d8d3a8cf33efc2548bc6f5406ab5a3d8630729030351" => :el_capitan
    sha256 "6a01cbaba92ed7538facca6acacf0eb792b7eed1a887bbfbd3d5a8afe580bb7f" => :yosemite
  end

  option "with-test", "Build with unit tests"
  option "with-embedded", "Build the embedded server"
  option "with-libedit", "Compile with editline wrapper instead of readline"
  option "with-archive-storage-engine", "Compile with the ARCHIVE storage engine enabled"
  option "with-blackhole-storage-engine", "Compile with the BLACKHOLE storage engine enabled"
  option "with-local-infile", "Build with local infile loading support"
  option "with-debug", "Build with debug support"

  deprecated_option "with-tests" => "with-test"
  deprecated_option "enable-local-infile" => "with-local-infile"
  deprecated_option "enable-debug" => "with-debug"

  depends_on :java => "1.7+"
  depends_on "cmake" => :build
  depends_on "pidof" unless MacOS.version >= :mountain_lion
  depends_on "openssl"

  conflicts_with "memcached", :because => "both install `bin/memcached`"
  conflicts_with "mysql", "mariadb", "percona-server",
    :because => "mysql, mariadb, and percona install the same binaries."

  fails_with :clang do
    build 500
    cause "https://article.gmane.org/gmane.comp.db.mysql.cluster/2085"
  end

  resource "boost" do
    url "https://downloads.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.bz2"
    sha256 "727a932322d94287b62abb1bd2d41723eec4356a7728909e38adb65ca25241ca"
  end

  def install
    # Make sure the var/mysql-cluster directory exists
    (var/"mysql-cluster").mkpath

    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace "configure.cmake", "(clock_gettime", "(everything_is_terrible"
    end

    args = [".",
            "-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DMYSQL_DATADIR=#{var}/mysql-cluster",
            "-DINSTALL_MANDIR=#{man}",
            "-DINSTALL_DOCDIR=#{doc}",
            "-DINSTALL_INFODIR=#{info}",
            # CMake prepends prefix, so use share.basename
            "-DINSTALL_MYSQLSHAREDIR=#{share.basename}/mysql",
            "-DWITH_SSL=yes",
            "-DDEFAULT_CHARSET=utf8",
            "-DDEFAULT_COLLATION=utf8_general_ci",
            "-DSYSCONFDIR=#{etc}"]

    # mysql-cluster >5.7.x mandates Boost as a requirement to build & has a
    # strict version check in place to ensure it only builds against expected
    # release.
    (buildpath/"boost_1_59_0").install resource("boost")
    args << "-DWITH_BOOST=#{buildpath}/boost_1_59_0"

    # To enable unit testing at build, we need to download the unit testing suite
    if build.with? "test"
      args << "-DENABLE_DOWNLOADS=ON"
    else
      args << "-DWITH_UNIT_TESTS=OFF"
    end

    # Build the embedded server
    args << "-DWITH_EMBEDDED_SERVER=ON" if build.with? "embedded"

    # Compile with readline unless libedit is explicitly chosen
    args << "-DWITH_READLINE=yes" if build.without? "libedit"

    # Compile with ARCHIVE engine enabled if chosen
    args << "-DWITH_ARCHIVE_STORAGE_ENGINE=1" if build.with? "archive-storage-engine"

    # Compile with BLACKHOLE engine enabled if chosen
    args << "-DWITH_BLACKHOLE_STORAGE_ENGINE=1" if build.with? "blackhole-storage-engine"

    # Build with local infile loading support
    args << "-DENABLED_LOCAL_INFILE=1" if build.with? "local-infile"

    # Build with debug support
    args << "-DWITH_DEBUG=1" if build.with? "debug"

    system "cmake", *args
    system "make"
    system "make", "install"

    # We don't want to keep a 240MB+ folder around most users won't need.
    (prefix/"mysql-test").cd do
      system "./mysql-test-run.pl", "status", "--vardir=#{Dir.mktmpdir}"
    end
    rm_rf prefix/"mysql-test"

    # Don't create databases inside of the prefix!
    # See: https://github.com/Homebrew/homebrew/issues/4975
    rm_rf prefix/"data"

    # Link the setup script into bin
    bin.install_symlink prefix/"scripts/mysql_install_db"

    # Fix up the control script and link into bin
    inreplace "#{prefix}/support-files/mysql.server",
              /^(PATH=".*)(")/,
              "\\1:#{HOMEBREW_PREFIX}/bin\\2"
    bin.install_symlink prefix/"support-files/mysql.server"

    libexec.install bin/"mcc_config.py"

    plist_path("ndb_mgmd").write ndb_mgmd_startup_plist("ndb_mgmd")
    plist_path("ndb_mgmd").chmod 0644
    plist_path("ndbd").write ndbd_startup_plist("ndbd")
    plist_path("ndbd").chmod 0644
    plist_path("mysqld").write mysqld_startup_plist("mysqld")
    plist_path("mysqld").chmod 0644
  end

  def post_install
    (var/"mysql-cluster/ndb_data").mkpath
    (var/"mysql-cluster/mysqld_data").mkpath
    (var/"mysql-cluster/conf").mkpath
    (var/"mysql-cluster/conf/my.cnf").write my_cnf unless File.exist? var/"mysql-cluster/conf/my.cnf"
    (var/"mysql-cluster/conf/config.ini").write config_ini unless File.exist? var/"mysql-cluster/conf/config.ini"
  end

  def caveats; <<-EOS.undent
    To get started with MySQL Cluster, read MySQL Cluster Quick Start at
      https://dev.mysql.com/downloads/cluster/

    Default configuration files have been created inside:
      #{var}/mysql-cluster
    Note that in a production system there are other parameters
    that you would set to tune the configuration.
    MySQL is configured to only allow connections from localhost by default

    Set up databases to run AS YOUR USER ACCOUNT with:
      unset TMPDIR
      mysql_install_db --verbose --user=`whoami` --basedir="#{opt_prefix}" --datadir=#{var}/mysql-cluster/mysqld_data --tmpdir=/tmp

    For a first cluster, you may start with a single MySQL Server (mysqld),
    a pair of Data Nodes (ndbd) and a single management node (ndb_mgmd):

      ndb_mgmd -f #{var}/mysql-cluster/conf/config.ini --initial --configdir=#{var}/mysql-cluster/conf/
      ndbd -c localhost:1186
      ndbd -c localhost:1186
      mysqld --defaults-file=#{var}/mysql-cluster/conf/my.cnf &
      mysql -h 127.0.0.1 -P 5000 -u root -p
      (Leave the password empty and press Enter)
        create database clusterdb;
        use clusterdb;
        create table simples (id int not null primary key) engine=ndb;
        insert into simples values (1),(2),(3),(4);
        select * from simples;

    To shutdown everything:

      mysqladmin -u root -p shutdown
      ndb_mgm -e shutdown
    EOS
  end

  def my_cnf; <<-EOCNF.undent
    [mysqld]
    ndbcluster
    datadir=#{var}/mysql-cluster/mysqld_data
    basedir=#{opt_prefix}
    port=5000
    # Only allow connections from localhost
    bind-address = 127.0.0.1
    EOCNF
  end

  def config_ini; <<-EOCNF.undent
    [ndb_mgmd]
    hostname=localhost
    datadir=#{var}/mysql-cluster/ndb_data
    NodeId=1

    [ndbd default]
    noofreplicas=2
    datadir=#{var}/mysql-cluster/ndb_data

    [ndbd]
    hostname=localhost
    NodeId=3

    [ndbd]
    hostname=localhost
    NodeId=4

    [mysqld]
    NodeId=50
    EOCNF
  end

  # Override Formula#plist_name
  def plist_name(extra = nil)
    extra ? super()+"-"+extra : super()+"-ndb_mgmd"
  end

  # Override Formula#plist_path
  def plist_path(extra = nil)
    extra ? super().dirname+(plist_name(extra)+".plist") : super()
  end

  plist_options :manual => "mysql.server start"

  def mysqld_startup_plist(name); <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name(name)}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/mysqld</string>
        <string>--defaults-file=#{var}/mysql-cluster/conf/my.cnf</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
    </dict>
    </plist>
    EOS
  end

  def ndb_mgmd_startup_plist(name); <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name(name)}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/ndb_mgmd</string>
        <string>--nodaemon</string>
        <string>-f</string>
        <string>#{var}/mysql-cluster/conf/config.ini</string>
        <string>--initial</string>
        <string>--configdir=#{var}/mysql-cluster/conf/</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
      <key>StandardOutPath</key>
      <string>#{var}/mysql-cluster/#{name}.log</string>
    </dict>
    </plist>
    EOS
  end

  def ndbd_startup_plist(name); <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name(name)}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/ndbd</string>
        <string>--nodaemon</string>
        <string>-c</string>
        <string>localhost:1186</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
      <key>StandardOutPath</key>
      <string>#{var}/mysql-cluster/#{name}.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    begin
      # Expects datadir to be a completely clean dir, which testpath isn't.
      dir = Dir.mktmpdir
      system bin/"mysqld", "--initialize-insecure", "--user=#{ENV["USER"]}",
      "--basedir=#{prefix}", "--datadir=#{dir}", "--tmpdir=#{dir}"

      pid = fork do
        exec bin/"mysqld", "--datadir=#{dir}"
      end
      sleep 2

      output = shell_output("curl 127.0.0.1:3306")
      output.force_encoding("ASCII-8BIT") if output.respond_to?(:force_encoding)
      assert_match version.to_s, output
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end
  end
end
