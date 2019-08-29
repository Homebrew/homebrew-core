class MysqlCluster < Formula
  desc "Shared-nothing clustering and auto-sharding for MySQL"
  homepage "https://www.mysql.com/products/cluster/"
  url "https://dev.mysql.com/get/Downloads/MySQL-Cluster-7.5/mysql-cluster-gpl-7.5.7.tar.gz"
  sha256 "c40551603a9aacc4db96416be7f15700af6039a2247b83c2dce637c793cb10d8"

  bottle do
    rebuild 1
    sha256 "c674f96367eada920fa37cf53d8ed2ec599989c4962b224b71e43143d719ee2d" => :mojave
    sha256 "5aeccf907d65e780dcf4272a48f13556307713338cad5eb34394c5f688461889" => :high_sierra
    sha256 "64d695dea06e09721948a623c2891876c4f3ba49cec6ffc1f1a08739a513babe" => :sierra
  end

  depends_on "cmake" => :build
  depends_on :java => "1.8"
  depends_on "openssl" # no OpenSSL 1.1 support

  conflicts_with "memcached", :because => "both install `bin/memcached`"
  conflicts_with "mysql", "mariadb", "percona-server",
    :because => "mysql, mariadb, and percona install the same binaries."
  conflicts_with "mysql-connector-c",
    :because => "both install `bin/my_print_defaults`"

  resource "boost" do
    url "https://downloads.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.bz2"
    sha256 "727a932322d94287b62abb1bd2d41723eec4356a7728909e38adb65ca25241ca"
  end

  def install
    # Make sure the var/mysql-cluster directory exists
    (var/"mysql-cluster").mkpath

    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    if MacOS.version == "10.11" && MacOS::Xcode.version >= "8.0"
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
            "-DSYSCONFDIR=#{etc}",
            "-DWITH_UNIT_TESTS=OFF",
            "-DWITH_READLINE=yes"]

    # mysql-cluster >5.7.x mandates Boost as a requirement to build & has a
    # strict version check in place to ensure it only builds against expected
    # release.
    (buildpath/"boost_1_59_0").install resource("boost")
    args << "-DWITH_BOOST=#{buildpath}/boost_1_59_0"

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

  def caveats; <<~EOS
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

  def my_cnf; <<~EOS
    [mysqld]
    ndbcluster
    datadir=#{var}/mysql-cluster/mysqld_data
    basedir=#{opt_prefix}
    port=5000
    # Only allow connections from localhost
    bind-address = 127.0.0.1
  EOS
  end

  def config_ini; <<~EOS
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
  EOS
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

  def mysqld_startup_plist(name); <<~EOS
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

  def ndb_mgmd_startup_plist(name); <<~EOS
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

  def ndbd_startup_plist(name); <<~EOS
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
