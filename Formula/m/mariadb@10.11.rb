class MariadbAT1011 < Formula
  desc "Drop-in replacement for MySQL"
  homepage "https://mariadb.org/"
  url "https://archive.mariadb.org/mariadb-10.11.8/source/mariadb-10.11.8.tar.gz"
  sha256 "5f04f3e33d9f1cbeff05e79c54d41d302630500c995aee72b0638e2f9dfcdf0f"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.mariadb.org/rest-api/mariadb/all-releases/?olderReleases=false"
    strategy :json do |json|
      json["releases"]&.map do |release|
        next unless release["release_number"]&.start_with?(version.major_minor)
        next if release["status"] != "stable"

        release["release_number"]
      end
    end
  end

  bottle do
    sha256 arm64_sonoma:   "4f6e2d479faad0d8b72733ecddeb8bcd901e3e44af0f8a537b9149e003fca4b7"
    sha256 arm64_ventura:  "c0554c4acc446a59734b8ceaf3d237d48df71b94eda2fb235f294ca29058f5a4"
    sha256 arm64_monterey: "31517459b00e1e9808a7e233550ae176be2f14487acd58b1dc03ae37ba011495"
    sha256 sonoma:         "2666257dbb03538e5e6e7c47d818c0f8b46d2246a55d2bac28486dfeab0f497b"
    sha256 ventura:        "0fa732a5c652e24de1488fac49122a6bfd2bca9474d8ca997475c6adc5b3ad7c"
    sha256 monterey:       "12dd76e2d2dd1c4ad97dc84a4e3fa1ab17814b9d040184ce6909aa852ec61357"
    sha256 x86_64_linux:   "c8be162eff79f8fd5f90bb2e9a8155ebd56fac9c498b311eea2b90d894d91bff"
  end

  keg_only :versioned_formula

  # See: https://mariadb.com/kb/en/changes-improvements-in-mariadb-1011/
  # End-of-life on 2028-02-16: https://mariadb.org/about/#maintenance-policy
  deprecate! date: "2028-02-16", because: :unsupported

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "pkg-config" => :build
  depends_on "groonga"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "krb5"
  uses_from_macos "libedit"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-pam"
    depends_on "readline" # uses libedit on macOS
  end

  fails_with gcc: "5"

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
    rm_rf prefix/"data"

    # Save space
    (prefix/"mysql-test").rmtree
    (prefix/"sql-bench").rmtree

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
