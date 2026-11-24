class Mariadb < Formula
  desc "Drop-in replacement for MySQL"
  homepage "https://mariadb.org/"
  url "https://archive.mariadb.org/mariadb-13.1.2/source/mariadb-13.1.2.tar.gz"
  sha256 "097bf3b7692ebbe8106a854af4ada1f4ecb0759c93ebd946b536fe9ef78eaa7a"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.mariadb.org/rest-api/mariadb/all-releases/?olderReleases=false"
    strategy :json do |json|
      json["releases"]&.map do |release|
        next if release["status"] != "stable"

        release["release_number"]
      end
    end
  end

  bottle do
    manifest_sha256 "fe7ae2f8e4a4456aa0dc9eece0d8cd842659a7cb9db02d3e430e3b2de3bfefe8"
    sha256 arm64_golden_gate: "104b0fbc4de0e23f942b487dc7b42e574ed91032f94dc1db87f4b516a0fb1d99"
    sha256 arm64_tahoe:       "8b31e117671db68de7d93ed506b300a137c48e1f39b86f1e2307611fae29ef7b"
    sha256 arm64_sequoia:     "207a32bd1c042a11dfa6eff856d2b7fd0122edd59557517995b89dbe32903a6d"
    sha256 arm64_linux:       "4bce72f2400622a8bea4c5f0cad9fad263b5a39dc9b4b9038ee64bb109073070"
    sha256 x86_64_linux:      "69c28a1193e9491de175de423899f3980d07b82b1f311525461b008b00641a1c"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "pkgconf" => :build
  depends_on "groonga"
  depends_on "lz4"
  depends_on "lzo"
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "krb5"
  uses_from_macos "libedit"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_macos do
    depends_on "openjdk" => :build
  end

  on_linux do
    depends_on "linux-pam"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "mysql", "percona-server", because: "mariadb, mysql, and percona install the same binaries"

  # Apply open PR to fix issue when using OpenSSL 4. This has been applied by
  # Debian Forky / Ubuntu Stonking since Aug/Sep 2026. MariaDB may end up merging
  # https://github.com/MariaDB/server/pull/5652 instead but it doesn't cleanly apply.
  patch do
    url "https://github.com/MariaDB/server/commit/5ca4ab639ad5f99d74f794b54ba1b4d6182ec2a9.patch?full_index=1"
    sha256 "a0cc83631f63368457f8880626a18bb791409dfe02a672989b94b205c2cefaef"
    type :unofficial
    resolves "https://github.com/MariaDB/server/pull/5029"
  end

  allow_network_access! :test

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

    # Fix user variable used by su_kill - Credit: https://stackoverflow.com/questions/59936589
    inreplace "#{prefix}/support-files/mysql.server", /^user='mysql'/, "user=$(whoami)"

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

  post_install_steps do
    # Make sure the var/mysql directory exists
    # Don't initialize database, it clashes when testing other MySQL-like implementations.
    init_data_dir "mysql", using: :mariadb, base: :var
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
