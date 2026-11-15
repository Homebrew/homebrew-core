class Mysql < Formula
  desc "Open source relational database management system"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-26.10/mysql-26.10.0.tar.gz"
  mirror "https://repo.mysql.com/apt/ubuntu/pool/mysql-innovation/m/mysql-community/mysql-community_26.10.0.orig.tar.gz"
  sha256 "984507622ddfa4d84ad23fc56ec5b5f18f4fda328af5a23e5f5b1a062301ea2c"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }
  revision 1
  compatibility_version 1

  livecheck do
    url "https://dev.mysql.com/downloads/mysql/?tpl=files&os=src",
        user_agent: :browser
    regex(/href=.*?mysql[._-](?:boost[._-])?v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "001dfd1b4f5aed976df07de0c1ae8820b20a589b0cd73d05e5c415d780209e99"
    sha256 arm64_tahoe:       "dfb7e53b85c1287da1f7d25eee0df4b5a1944bdf4214a2f92cb5cb4811332174"
    sha256 arm64_sequoia:     "102d1fd659336a5c50f2862c8f92f6ab5e78043611a5d97e6761b21e46a65863"
    sha256 arm64_linux:       "45b0bc21b2d0864c46d0199c830d1091270934206f5944188d23c9d602cc70cc"
    sha256 x86_64_linux:      "72ef41ad06530721ac66715e7f3560c20ffbb771f8edf000382cac4c8329d55f"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "icu4c@79"
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "protobuf"
  depends_on "zlib-ng-compat" # Zlib 1.2.13+
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "libedit"

  on_ventura :or_older do
    depends_on "llvm"
    fails_with :clang do
      cause <<~EOS
        std::string_view is not fully compatible with the libc++ shipped
        with ventura, so we need to use the LLVM libc++ instead.
      EOS
    end
  end

  on_linux do
    depends_on "patchelf" => :build
    depends_on "libtirpc"
  end

  conflicts_with "mariadb", "percona-server", because: "both install the same binaries"

  fails_with :gcc do
    version "12"
    cause "fails handling PROTOBUF_FUTURE_ADD_EARLY_WARN_UNUSED"
  end

  # Patch out check for Homebrew `boost`.
  # This should not be necessary when building inside `brew`.
  # https://github.com/Homebrew/homebrew-test-bot/pull/820
  patch do
    file "Patches/mysql/remove-boost-check.diff"
    type :unofficial
  end

  # Use `my_char_traits`, as libc++ 19 removed `std::char_traits<unsigned char>`.
  patch do
    file "Patches/mysql/innobase-char_traits.diff"
    type :unofficial
  end

  def datadir
    var/"mysql"
  end

  def icu4c = deps.map(&:name).find { |dep| dep.start_with?("icu4c@") }

  def openssl = deps.map(&:name).find { |dep| dep.start_with?("openssl@") }

  def install
    # Remove bundled libraries other than explicitly allowed below.
    # `boost` and `rapidjson` must use bundled copy due to patches.
    # `lz4` is still needed due to xxhash.c used by mysqlgcs
    keep = %w[boost duktape libbacktrace libcno lz4 rapidjson unordered_dense xxhash]
    (buildpath/"extra").each_child { |dir| rm_r(dir) unless keep.include?(dir.basename.to_s) }

    if OS.linux?
      # Disable ABI checking
      inreplace "cmake/abi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0"
    elsif MacOS.version <= :ventura
      ENV.append "LDFLAGS", "-L#{formula_opt_lib("llvm")}/unwind -lunwind"
      # When using Homebrew's superenv shims, we need to use HOMEBREW_LIBRARY_PATHS
      # rather than LDFLAGS for libc++ in order to correctly link to LLVM's libc++.
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", formula_opt_lib("llvm")/"c++"
    end

    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    # -DWITH_FIDO=system isn't set as WebAuthn is disabled and bundled copy was removed.
    # Formula paths are set to avoid HOMEBREW_HOME logic in CMake scripts
    args = %W[
      -DCOMPILATION_COMMENT=Homebrew
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MANDIR=share/man
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DINSTALL_PLUGINDIR=lib/plugin
      -DMYSQL_DATADIR=#{datadir}
      -DSYSCONFDIR=#{etc}
      -DBISON_EXECUTABLE=#{formula_opt_bin("bison")}/bison
      -DOPENSSL_ROOT_DIR=#{formula_opt_prefix(openssl)}
      -DWITH_ICU=#{formula_opt_prefix(icu4c)}
      -DWITH_AUTHENTICATION_WEBAUTHN=OFF
      -DWITH_SYSTEM_LIBS=ON
      -DWITH_EDITLINE=system
      -DWITH_LZ4=system
      -DWITH_PROTOBUF=system
      -DWITH_SSL=system
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
      -DWITH_UNIT_TESTS=OFF
      -DWITH_MYSQL_SERVER_TELEMETRY=OFF
      -DWITH_MYSQL_CLIENT_TELEMETRY=OFF
    ]

    if OS.linux?
      args << "-DCURL_LIBRARY=#{formula_opt_lib("curl")}"
      args << "-DCURL_INCLUDE_DIR=#{formula_opt_include("curl")}"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # mysqld logs this under the cgroup memory limits of Homebrew CI, failing the check below
    inreplace prefix/"mysql-test/include/mtr_warnings.sql", '("THE_LAST_SUPPRESSION");',
              "(\"Server ignores the discovered container restrictions\"),\n (\"THE_LAST_SUPPRESSION\");"

    cd prefix/"mysql-test" do
      system "./mysql-test-run.pl", "check", "--vardir=#{buildpath}/mysql-test-vardir"
    ensure
      status_log_file = buildpath/"mysql-test-vardir/log/main.status/status.log"
      logs.install status_log_file if status_log_file.exist?
    end

    # Remove the tests directory
    rm_r(prefix/"mysql-test")

    # Fix up the control script and link into bin.
    inreplace prefix/"support-files/mysql.server",
              /^(PATH=".*)(")/,
              "\\1:#{HOMEBREW_PREFIX}/bin\\2"
    bin.install_symlink prefix/"support-files/mysql.server"

    # Install my.cnf that binds to 127.0.0.1 by default
    (buildpath/"my.cnf").write <<~INI
      # Default Homebrew MySQL server config
      [mysqld]
      # Only allow connections from localhost
      bind-address = 127.0.0.1
      mysqlx-bind-address = 127.0.0.1
    INI
    etc.install "my.cnf"
  end

  post_install_steps do
    # Make sure the var/mysql directory exists
    # Don't initialize database, it clashes when testing other MySQL-like implementations.
    init_data_dir "mysql", using: :mysql, base: :var
  end

  def caveats
    <<~EOS
      A "/etc/my.cnf" or "/etc/mysql/my.cnf" from another install may interfere
      with a Homebrew-built server starting up correctly.

      Upgrading from MySQL <8.4 to MySQL >9.0 requires running MySQL 8.4 first:
       - brew services stop mysql
       - brew install mysql@8.4
       - brew services start mysql@8.4
       - brew services stop mysql@8.4
       - brew services start mysql

      We've installed your MySQL database without a root password. To secure it run:
          mysql_secure_installation

      MySQL is configured to only allow connections from localhost by default

      To connect run:
          mysql -u root
    EOS
  end

  service do
    run [opt_bin/"mysqld_safe", "--datadir=#{var}/mysql"]
    keep_alive true
    working_dir var/"mysql"
  end

  test do
    (testpath/"mysql").mkpath
    (testpath/"tmp").mkpath

    port = free_port
    socket = testpath/"mysql.sock"
    mysqld_args = %W[
      --no-defaults
      --mysqlx=OFF
      --user=#{ENV["USER"]}
      --port=#{port}
      --socket=#{socket}
      --basedir=#{prefix}
      --datadir=#{testpath}/mysql
      --tmpdir=#{testpath}/tmp
    ]
    client_args = %W[
      --port=#{port}
      --socket=#{socket}
      --user=root
      --password=
    ]

    system bin/"mysqld", *mysqld_args, "--initialize-insecure"
    pid = spawn(bin/"mysqld", *mysqld_args)
    begin
      sleep 5
      output = shell_output("#{bin}/mysql #{client_args.join(" ")} --execute='show databases;'")
      assert_match "information_schema", output
    ensure
      system bin/"mysqladmin", *client_args, "shutdown"
      Process.kill "TERM", pid
    end
  end
end
