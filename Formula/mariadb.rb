class Mariadb < Formula
  desc "Drop-in replacement for MySQL"
  homepage "https://mariadb.org/"
  url "https://downloads.mariadb.com/MariaDB/mariadb-10.7.3/source/mariadb-10.7.3.tar.gz"
  sha256 "da286919ffc9c913282202349709b6ba4ebcd342815e8dae0aa6b6bd8f515cd4"
  license "GPL-2.0-only"

  # This uses a placeholder regex to satisfy the `PageMatch` strategy
  # requirement. In the future, this will be updated to use a `Json` strategy
  # and we can remove the unused regex at that time.
  livecheck do
    url "https://downloads.mariadb.org/rest-api/mariadb/all-releases/?olderReleases=false"
    regex(/unused/i)
    strategy :page_match do |page|
      json = JSON.parse(page)
      json["releases"]&.map do |release|
        release["status"].include?("stable") ? release["release_number"] : nil
      end
    end
  end

  bottle do
    sha256 arm64_monterey: "07c81d2b029d536ddb73e4b3b1b9502ac8f7cfc2d6aafcb0e33fcf15cf5d3873"
    sha256 arm64_big_sur:  "5d29f5d7ae15b68a7e7e99c309099213876db8fdb04f414e083f7ae66610f468"
    sha256 monterey:       "e6d7a6ad7552ab2c5a658f91af7388aa0d33129386ab03ceb5249c9c3beb42c2"
    sha256 big_sur:        "1dee509380202236093d1f290d5cb8b8d71678b0f1b3bc524c657432c36c59bf"
    sha256 catalina:       "01843361337272e3023e4dd3b88171d6549258725ecd741fc47942ba972f6e50"
    sha256 x86_64_linux:   "1346c4ed3921511ebd0b819f6a7756ed0f7e8bedc7cb92c870957b300e2e2bbd"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fmt"
  depends_on "groonga"
  depends_on "openssl@1.1"
  depends_on "pcre2"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
    depends_on "linux-pam"
    depends_on "readline" # uses libedit on macOS
  end

  conflicts_with "mysql", "percona-server",
    because: "mariadb, mysql, and percona install the same binaries"

  conflicts_with "mytop", because: "both install `mytop` binaries"
  conflicts_with "mariadb-connector-c", because: "both install `mariadb_config`"

  fails_with gcc: "5"

  patch :DATA

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
    # -DWITH_LIBFMT=system can't find fmt
    args = %W[
      -DMYSQL_DATADIR=#{var}/mysql
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_MANDIR=share/man
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DWITH_SSL=system
      -DWITH_UNIT_TESTS=OFF
      -DDEFAULT_CHARSET=utf8mb4
      -DDEFAULT_COLLATION=utf8mb4_general_ci
      -DINSTALL_SYSCONFDIR=#{etc}
      -DCOMPILATION_COMMENT=#{tap.user}
    ]

    if OS.linux?
      args << "-DWITH_NUMA=OFF"
      args << "-DENABLE_DTRACE=NO"
      args << "-DCONNECT_WITH_JDBC=OFF"
    end

    # Disable RocksDB on Apple Silicon (currently not supported)
    args << "-DPLUGIN_ROCKSDB=NO" if Hardware::CPU.arm?

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
      inreplace "#{bin}/#{f}", "$(dirname \"$0\")/wsrep_sst_common",
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

    # Don't initialize database, it clashes when testing other MySQL-like implementations.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

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

  service do
    run [opt_bin/"mysqld_safe", "--datadir=#{var}/mysql"]
    keep_alive true
    working_dir var
  end

  test do
    (testpath/"mysql").mkpath
    (testpath/"tmp").mkpath
    system bin/"mysql_install_db", "--no-defaults", "--user=#{ENV["USER"]}",
      "--basedir=#{prefix}", "--datadir=#{testpath}/mysql", "--tmpdir=#{testpath}/tmp",
      "--auth-root-authentication-method=normal"
    port = free_port
    fork do
      system "#{bin}/mysqld", "--no-defaults", "--user=#{ENV["USER"]}",
        "--datadir=#{testpath}/mysql", "--port=#{port}", "--tmpdir=#{testpath}/tmp"
    end
    sleep 5
    assert_match "information_schema",
      shell_output("#{bin}/mysql --port=#{port} --user=root --password= --execute='show databases;'")
    system "#{bin}/mysqladmin", "--port=#{port}", "--user=root", "--password=", "shutdown"
  end
end
<<<<<<< HEAD
=======

__END__
diff --git a/client/mysql.cc b/client/mysql.cc
index 37f506a99cd..6bfbfd87b95 100644
--- a/client/mysql.cc
+++ b/client/mysql.cc
@@ -2743,7 +2743,7 @@ static void initialize_readline ()
   rl_terminal_name= getenv("TERM");
 
   /* Tell the completer that we want a crack first. */
-#if defined(USE_NEW_READLINE_INTERFACE)
+#if defined(USE_NEW_READLINE_INTERFACE) && !defined(__APPLE_CC__)
   rl_attempted_completion_function= (rl_completion_func_t*)&new_mysql_completion;
   rl_completion_entry_function= (rl_compentry_func_t*)&no_completion;
 
@@ -2753,7 +2753,7 @@ static void initialize_readline ()
   setlocale(LC_ALL,""); /* so as libedit use isprint */
 #endif
   rl_attempted_completion_function= (CPPFunction*)&new_mysql_completion;
-  rl_completion_entry_function= &no_completion;
+  /* rl_completion_entry_function= &no_completion; */
   rl_add_defun("magic-space", (Function*)&fake_magic_space, -1);
 #else
   rl_attempted_completion_function= (CPPFunction*)&new_mysql_completion;
>>>>>>> 8f3661b2e7b (mariadb 10.7.3)
