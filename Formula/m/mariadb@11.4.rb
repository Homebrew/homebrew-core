class MariadbAT114 < Formula
  desc "Drop-in replacement for MySQL"
  homepage "https://mariadb.org/"
  url "https://archive.mariadb.org/mariadb-11.4.8/source/mariadb-11.4.8.tar.gz"
  sha256 "52fa4dca2c5f80afc1667d523a27c06176d98532298a6b0c31ed73505f49e15c"
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
    sha256 arm64_tahoe:   "1f692e76c6122c735234fa72524279f9a6eed5690d4c83298b675997b11824d1"
    sha256 arm64_sequoia: "4082ad34dd185273f495053a46606eb25b6ba4c874e1600d583534668a789169"
    sha256 arm64_sonoma:  "1cb6a11a038905d7a184714325058a8150bf27163e5744483b1bf9f928cfc146"
    sha256 arm64_ventura: "d43c7c65aa17f0192ef7aaca3d265cd34325881c0cbc04867c3c23071756d5bd"
    sha256 sonoma:        "caed233d882908bd5b75ea4495ad60f5230d569dd83e84efe4877441947cfc6e"
    sha256 ventura:       "f3d60f3215670b686323ad11eda4d9d3359f4d607c7904d11baa59aa55fa49fc"
    sha256 arm64_linux:   "d6163a8ef6cfd6da62ab9431fdf10134067c8944ad82eae8f576b2bcbed2bbdc"
    sha256 x86_64_linux:  "d0277f31419dc5140616c2f09e7fcc905d7a5f8e3ebf9bf3448a1927662100c3"
  end

  keg_only :versioned_formula

  # See: https://mariadb.com/kb/en/changes-improvements-in-mariadb-11-4/
  # End-of-life on 2029-05-29: https://mariadb.org/about/#maintenance-policy
  deprecate! date: "2029-05-29", because: :unsupported

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "pkgconf" => :build
  depends_on "groonga"
  depends_on "lz4"
  depends_on "lzo"
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

  on_macos do
    depends_on "openjdk" => :build
  end

  on_linux do
    depends_on "linux-pam"
  end

  def install
    ENV.runtime_cpu_detection

    # Set basedir and ldata so that mysql_install_db can find the server
    # without needing an explicit path to be set. This can still
    # be overridden by calling --basedir= when calling.
    inreplace "scripts/mysql_install_db.sh" do |s|
      s.change_make_var! "basedir", "\"#{prefix}\""
      s.change_make_var! "ldata", "\"#{var}/mysql\""
    end

    # Use brew groonga
    rm_r "storage/mroonga/vendor/groonga"
    rm_r "extra/wolfssl"
    rm_r "zlib"

    # -DINSTALL_* are relative to prefix
    args = %W[
      -DMYSQL_DATADIR=#{var}/mysql
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_MANDIR=share/man
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DWITH_LIBFMT=system
      -DWITH_PCRE=system
      -DWITH_SSL=system
      -DWITH_ZLIB=system
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

    system "cmake", "-S", ".", "-B", "_build", *std_cmake_args, *args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    # Fix my.cnf to point to #{etc} instead of /etc
    (etc/"my.cnf.d").mkpath
    inreplace "#{etc}/my.cnf", "!includedir /etc/my.cnf.d",
                               "!includedir #{etc}/my.cnf.d"
    touch etc/"my.cnf.d/.homebrew_dont_prune_me"

    # Save space
    rm_r(prefix/"mariadb-test")
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
    (buildpath/"my.cnf").write <<~INI
      # Default Homebrew MySQL server config
      [mysqld]
      # Only allow connections from localhost
      bind-address = 127.0.0.1
    INI
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
    run [opt_bin/"mariadbd-safe", "--datadir=#{var}/mysql"]
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
