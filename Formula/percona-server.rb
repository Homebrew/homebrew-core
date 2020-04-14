class PerconaServer < Formula
  desc "Drop-in MySQL replacement"
  homepage "https://www.percona.com"
  url "https://www.percona.com/downloads/Percona-Server-8.0/Percona-Server-8.0.19-10/source/tarball/percona-server-8.0.19-10.tar.gz"
  sha256 "b819d81b9cdef497dd5fd1044ddb033d222b986cf610cb5d4bb1fa5010dba580"

  bottle do
    sha256 "1d185a20987cc90ddadf67b3a0bfa99c65b5e903c04cbf5618c6840d0e5c2c52" => :catalina
    sha256 "698a9e8aeb74952720a1ec7173504ac81e1bedb37df33bcdbdc73c6406f43258" => :mojave
    sha256 "e1ef93655f32e10839745355c8b54801eb5400df0e3095bf6a77db217a648c20" => :high_sierra
  end

  pour_bottle? do
    reason "The bottle needs a var/mysql datadir (yours is var/percona)."
    satisfy { datadir == var/"mysql" }
  end

  depends_on "cmake" => :build

  # https://github.com/Homebrew/homebrew-core/issues/1475
  # Needs at least Clang 3.3, which shipped alongside Lion.
  # Note: MySQL themselves don't support anything below Sierra.
  depends_on :macos => :yosemite
  depends_on "openssl@1.1"

  conflicts_with "mariadb", "mysql",
    :because => "percona, mariadb, and mysql install the same binaries."

  # https://bugs.mysql.com/bug.php?id=86711
  # https://github.com/Homebrew/homebrew-core/pull/20538
  fails_with :clang do
    build 800
    cause "Wrong inlining with Clang 8.0, see MySQL Bug #86711"
  end

  resource "boost" do
    url "https://dl.bintray.com/boostorg/release/1.70.0/source/boost_1_70_0.tar.bz2"
    sha256 "430ae8354789de4fd19ee52f3b1f739e1fba576f0aded0897c3c2bc00fb38778"
  end

  # Where the database files should be located. Existing installs have them
  # under var/percona, but going forward they will be under var/mysql to be
  # shared with the mysql and mariadb formulae.
  def datadir
    @datadir ||= (var/"percona").directory? ? var/"percona" : var/"mysql"
  end

  def install
    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DFORCE_INSOURCE_BUILD=1
      -DCOMPILATION_COMMENT=Homebrew
      -DDEFAULT_CHARSET=utf8mb4
      -DDEFAULT_COLLATION=utf8mb4_0900_ai_ci
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MANDIR=share/man
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DINSTALL_PLUGINDIR=lib/percona-server/plugin
      -DMYSQL_DATADIR=#{datadir}
      -DSYSCONFDIR=#{etc}
      -DWITH_SSL=yes
      -DWITH_UNIT_TESTS=OFF
      -DWITH_EMBEDDED_SERVER=ON
      -DENABLED_LOCAL_INFILE=1
      -DWITH_INNODB_MEMCACHED=ON
      -DWITH_EDITLINE=system
    ]

    # MySQL >5.7.x mandates Boost as a requirement to build & has a strict
    # version check in place to ensure it only builds against expected release.
    # This is problematic when Boost releases don't align with MySQL releases.
    (buildpath/"boost").install resource("boost")
    args << "-DWITH_BOOST=#{buildpath}/boost"

    # Percona MyRocks does not compile on macOS
    # https://bugs.launchpad.net/percona-server/+bug/1741639
    args.concat %w[-DWITHOUT_ROCKSDB=1]

    # TokuDB does not compile on macOS
    # https://bugs.launchpad.net/percona-server/+bug/1531446
    args.concat %w[-DWITHOUT_TOKUDB=1]

    system "cmake", ".", *std_cmake_args, *args
    system "make"
    system "make", "install"

    (prefix/"mysql-test").cd do
      system "./mysql-test-run.pl", "status", "--vardir=#{Dir.mktmpdir}"
    end

    # Remove the tests directory
    rm_rf prefix/"mysql-test"

    # Don't create databases inside of the prefix!
    # See: https://github.com/Homebrew/homebrew/issues/4975
    rm_rf prefix/"data"

    # Fix up the control script and link into bin.
    inreplace "#{prefix}/support-files/mysql.server",
              /^(PATH=".*)(")/,
              "\\1:#{HOMEBREW_PREFIX}/bin\\2"
    bin.install_symlink prefix/"support-files/mysql.server"

    # Install my.cnf that binds to 127.0.0.1 by default
    (buildpath/"my.cnf").write <<~EOS
      # Default Homebrew MySQL server config
      [mysqld]
      # Only allow connections from localhost
      bind-address = 127.0.0.1
    EOS
    etc.install "my.cnf"
  end

  def post_install
    # Make sure the datadir exists
    datadir.mkpath
    unless (datadir/"mysql/user.frm").exist?
      ENV["TMPDIR"] = nil
      system bin/"mysqld", "--initialize-insecure", "--user=#{ENV["USER"]}",
        "--basedir=#{prefix}", "--datadir=#{datadir}", "--tmpdir=/tmp"
    end
  end

  def caveats
    s = <<~EOS
      We've installed your MySQL database without a root password. To secure it run:
          mysql_secure_installation
      MySQL is configured to only allow connections from localhost by default
      To connect run:
          mysql -uroot
    EOS
    if (my_cnf = ["/etc/my.cnf", "/etc/mysql/my.cnf"].find { |x| File.exist? x })
      s += <<~EOS
        A "#{my_cnf}" from another install may interfere with a Homebrew-built
        server starting up correctly.
      EOS
    end
    s
  end

  plist_options :manual => "mysql.server start"

  def plist
    <<~EOS
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
          <string>#{opt_bin}/mysqld_safe</string>
          <string>--datadir=#{datadir}</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{datadir}</string>
      </dict>
      </plist>
    EOS
  end

  test do
    # Expects datadir to be a completely clean dir, which testpath isn't.
    dir = Dir.mktmpdir
    system bin/"mysqld", "--initialize-insecure", "--user=#{ENV["USER"]}",
    "--basedir=#{prefix}", "--datadir=#{dir}", "--tmpdir=#{dir}"

    pid = fork do
      exec bin/"mysqld", "--bind-address=127.0.0.1", "--datadir=#{dir}"
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
