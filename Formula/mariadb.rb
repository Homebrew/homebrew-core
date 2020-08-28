class Mariadb < Formula
  desc "Drop-in replacement for MySQL"
  homepage "https://mariadb.org/"
  url "https://downloads.mariadb.com/MariaDB/mariadb-10.5.5/source/mariadb-10.5.5.tar.gz"
  sha256 "cf6b2c061754c07bbb1d20b29ae111bf2d098297c9b8c321b810638a179088a4"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.mariadb.org/"
    regex(/Download v?(\d+(?:\.\d+)+) Stable Now/i)
  end

  bottle do
    sha256 "df8622183262cb4871480d909e3144fa767a0dba995929e5ddb72d310d1f6ffa" => :catalina
    sha256 "ba7afe3313015e58b9ca9c9b17178ebbbb6b804239b31957cfaead678e31aa86" => :mojave
    sha256 "66dfcb470c80d0b7d0b56985e84ee36af5bb4c0c488fe02327f560cdb713785e" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "groonga"
  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "bzip2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  conflicts_with "mysql", "percona-server",
    because: "mariadb, mysql, and percona install the same binaries"
  conflicts_with "mytop", because: "both install `mytop` binaries"
  conflicts_with "mariadb-connector-c", because: "both install `mariadb_config`"

  def install
    # Set basedir and ldata so that mysql_install_db can find the server
    # without needing an explicit path to be set. This can still
    # be overridden by calling --basedir= when calling.
    inreplace "scripts/mysql_install_db.sh" do |s|
      s.change_make_var! "basedir", "\"#{prefix}\""
      s.change_make_var! "ldata", "\"#{var}/mysql\""
    end

    # Use brew groonga
    rm_r "storage/mroonga/vendor/groonga"

    # -DINSTALL_* are relative to prefix
    args = %W[
      -DMYSQL_DATADIR=#{var}/mysql
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_MANDIR=share/man
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DWITH_PCRE=bundled
      -DWITH_READLINE=yes
      -DWITH_SSL=yes
      -DWITH_UNIT_TESTS=OFF
      -DDEFAULT_CHARSET=utf8mb4
      -DDEFAULT_COLLATION=utf8mb4_general_ci
      -DINSTALL_SYSCONFDIR=#{etc}
      -DCOMPILATION_COMMENT=Homebrew
    ]

    # disable TokuDB, which is currently not supported on macOS
    args << "-DPLUGIN_TOKUDB=NO"

    system "cmake", ".", *std_cmake_args, *args
    system "make"
    system "make", "install"

    # Fix my.cnf to point to #{etc} instead of /etc
    (etc/"my.cnf.d").mkpath
    inreplace "#{etc}/my.cnf", "!includedir /etc/my.cnf.d",
                               "!includedir #{etc}/my.cnf.d"
    touch etc/"my.cnf.d/.homebrew_dont_prune_me"

    # Don't create databases inside of the prefix!
    # See: https://github.com/Homebrew/homebrew/issues/4975
    rm_rf prefix/"data"

    # Save space
    (prefix/"mysql-test").rmtree
    (prefix/"sql-bench").rmtree

    # Link the setup script into bin
    bin.install_symlink prefix/"scripts/mysql_install_db"

    # Fix up the control script and link into bin
    inreplace "#{prefix}/support-files/mysql.server", /^(PATH=".*)(")/, "\\1:#{HOMEBREW_PREFIX}/bin\\2"

    bin.install_symlink prefix/"support-files/mysql.server"

    # Move sourced non-executable out of bin into libexec
    libexec.install "#{bin}/wsrep_sst_common"
    # Fix up references to wsrep_sst_common
    %w[
      wsrep_sst_mysqldump
      wsrep_sst_rsync
      wsrep_sst_mariabackup
    ].each do |f|
      inreplace "#{bin}/#{f}", "$(dirname $0)/wsrep_sst_common",
                               "#{libexec}/wsrep_sst_common"
    end

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
    # Make sure the var/mysql directory exists
    (var/"mysql").mkpath
    unless File.exist? "#{var}/mysql/mysql/user.frm"
      ENV["TMPDIR"] = nil
      system "#{bin}/mysql_install_db", "--verbose", "--user=#{ENV["USER"]}",
        "--basedir=#{prefix}", "--datadir=#{var}/mysql", "--tmpdir=/tmp"
    end
  end

  def caveats
    <<~EOS
      A "/etc/my.cnf" from another install may interfere with a Homebrew-built
      server starting up correctly.

      MySQL is configured to only allow connections from localhost by default
    EOS
  end

  plist_options manual: "mysql.server start"

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
          <string>--datadir=#{var}/mysql</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
      </dict>
      </plist>
    EOS
  end

  test do
    system bin/"mysqld", "--version"
    prune_file = etc/"my.cnf.d/.homebrew_dont_prune_me"
    assert_predicate prune_file, :exist?, "Failed to find #{prune_file}!"
  end
end
