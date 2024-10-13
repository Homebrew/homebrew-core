class MariadbAT109 < Formula
  desc "Drop-in replacement for MySQL"
  homepage "https://mariadb.org/"
  url "https://archive.mariadb.org/mariadb-10.9.8/source/mariadb-10.9.8.tar.gz"
  sha256 "fcdc6f73882477c20310e795a02f746e54934aa7a8b368900bd45e78a5daf6ed"
  license "GPL-2.0-only"

  bottle do
    sha256 arm64_sonoma:   "2026b53c5752ce6113ed7c8af1318fdbc0e0d6733115b8dada7bd035cf9bf7c4"
    sha256 arm64_ventura:  "65cb2f2fdd5c29ad8f14f9f0a55970b61285fa2be6e5ed29dcdfa1872638b5c8"
    sha256 arm64_monterey: "1d9aa2dcc5ec1cc3856d7d3caf36b98eee15044105e7df4d44c43c7eba9e2547"
    sha256 arm64_big_sur:  "4caba5b164a403900c0678b4407c05b05b98458d9aaa63e0661421d8548a58c4"
    sha256 sonoma:         "206df40f0fb3bae52c8edb5994260ae35e7090ec9bdf39bc8b83c9cb13701418"
    sha256 ventura:        "7d10b5f059ddab6df41cffe7c0956307b0a5dbade98a317aa39b3d414ba01708"
    sha256 monterey:       "6f76bcbba2e365771130061f42b8618dd5c33783507aa8257bc151e27ecab0f5"
    sha256 big_sur:        "404272fdb775d32dd35cea91a4affb3e2a7bd938f84ef7ad038f3bede3edc52d"
    sha256 x86_64_linux:   "703f2525b34e8745ca5586a4372eba4380cda8a32504f70d10f1105647391314"
  end

  keg_only :versioned_formula

  # See: https://mariadb.com/kb/en/changes-improvements-in-mariadb-109/
  # End-of-life on 2023-08-22: https://mariadb.org/about/#maintenance-policy
  disable! date: "2024-07-26", because: :unsupported

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "pkg-config" => :build
  depends_on "groonga"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-pam"
    depends_on "readline" # uses libedit on macOS
  end

  fails_with gcc: "5"

  # Fix libfmt usage.
  # https://github.com/MariaDB/server/pull/2732
  patch do
    url "https://github.com/MariaDB/server/commit/f4cec369a392c8a6056207012992ad4a5639965a.patch?full_index=1"
    sha256 "1851d5ae209c770e8fd1ba834b840be12d7b537b96c7efa3d4e7c9523f188912"
  end
  patch do
    url "https://github.com/MariaDB/server/commit/cd5808eb8da13c5626d4bdeb452cef6ada29cb1d.patch?full_index=1"
    sha256 "4d288f82f56c61278aefecba8a90d214810b754e234f40b338e8cc809e0369e9"
  end

  def install
    ENV.cxx11

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
      -DWITH_LIBFMT=system
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

    system "cmake", "-S", ".", "-B", "_build", *std_cmake_args, *args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    # Fix my.cnf to point to #{etc} instead of /etc
    (etc/"my.cnf.d").mkpath
    inreplace "#{etc}/my.cnf", "!includedir /etc/my.cnf.d",
                               "!includedir #{etc}/my.cnf.d"
    touch etc/"my.cnf.d/.homebrew_dont_prune_me"

    # Don't create databases inside of the prefix!
    # See: https://github.com/Homebrew/homebrew/issues/4975
    rm_r(prefix/"data")

    # Save space
    rm_r(prefix/"mysql-test")
    rm_r(prefix/"sql-bench")

    # Link the setup scripts into bin
    bin.install_symlink [
      prefix/"scripts/mariadb-install-db",
      prefix/"scripts/mysql_install_db",
    ]

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
      system bin/"mysql_install_db", "--verbose", "--user=#{ENV["USER"]}",
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
      system bin/"mysqld", "--no-defaults", "--user=#{ENV["USER"]}",
        "--datadir=#{testpath}/mysql", "--port=#{port}", "--tmpdir=#{testpath}/tmp"
    end
    sleep 5
    assert_match "information_schema",
      shell_output("#{bin}/mysql --port=#{port} --user=root --password= --execute='show databases;'")
    system bin/"mysqladmin", "--port=#{port}", "--user=root", "--password=", "shutdown"
  end
end
