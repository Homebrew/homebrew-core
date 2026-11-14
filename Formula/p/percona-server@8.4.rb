class PerconaServerAT84 < Formula
  desc "Drop-in MySQL replacement"
  homepage "https://www.percona.com"
  url "https://downloads.percona.com/downloads/Percona-Server-8.4/Percona-Server-8.4.11-12/source/tarball/percona-server-8.4.11-12.tar.gz"
  sha256 "9cd754cec8f2494622edf5458a31348680ba1d4868c38b2312c5f0f28c257be1"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.percona.com/wp-admin/admin-ajax.php", post_form: {
      action:     "percona_downloads",
      product_id: "Percona-Server-#{version.major_minor}",
    }
    regex(/^Percona-Server-v?(\d+(?:[.-]\d+)+)$/i)
    strategy :json do |json, regex|
      json.dig("data", "versions")&.filter_map do |version|
        # Convert a version like 1.2.3-4.0 to 1.2.3-4 (but leave a version like
        # 1.2.3-4.5 as-is).
        version[regex, 1]&.sub(/(-\d+)\.0$/, '\1')
      end
    end
  end

  bottle do
    sha256 arm64_golden_gate: "add2efddb3585b052628be4e86939d88ad10bf66002fe9a4b63fe5636b4337f5"
    sha256 arm64_tahoe:       "030dcc84c143d228b416ce00541e904ec7954d4021f44e4fa28ed99fc305fd36"
    sha256 arm64_sequoia:     "41da6ecac6730a14b9e9f36dd46b0df6a76c09f05a8cec01e6995c1dea0e8c20"
    sha256 arm64_linux:       "3260e698662ce1563e0ddd8780546c3808b1344343bf3efb08a3da9ddc0b248c"
    sha256 x86_64_linux:      "27bde79b0ff1d8f56f90a5fd5073433e4b69c84b59b5d005b1054e78407b1c3b"
  end

  keg_only :versioned_formula

  # https://www.percona.com/services/policies/percona-software-support-lifecycle
  deprecate! date: "2032-04-30", because: :unsupported

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "icu4c@79"
  depends_on "libfido2"
  depends_on "lz4"
  depends_on "openldap" # Needs `ldap_set_urllist_proc`, not provided by LDAP.framework
  depends_on "openssl@4"
  depends_on "protobuf"
  depends_on "zlib-ng-compat" # Zlib 1.2.13+
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"
  uses_from_macos "libedit"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "libtirpc"
  end

  # https://github.com/percona/percona-server/blob/8.4/cmake/os/Linux.cmake
  fails_with :gcc do
    version "9"
    cause "Requires GCC 10 or newer"
  end

  # Apply Debian's MySQL patch to fix build with OpenSSL 4
  patch do
    url "https://salsa.debian.org/mariadb-team/mysql/-/raw/ac6576612c0afddccebf939fccedacc3b97db567/debian/patches/support-openssl4.patch"
    sha256 "fd0eb6d47ce5aaef43e58240d9884d04b1ee30fd3c57395b405d9400ae136a02"
    type :unofficial
  end

  # Patch out check for Homebrew `boost`.
  # This should not be necessary when building inside `brew`.
  # https://github.com/Homebrew/homebrew-test-bot/pull/820
  patch do
    file "Patches/mysql/remove-boost-check.diff"
    type :unofficial
  end

  def datadir
    var/"mysql"
  end

  def install
    # Remove bundled libraries other than explicitly allowed below.
    # `boost` and `rapidjson` must use bundled copy due to patches.
    # `lz4` is still needed due to xxhash.c used by mysqlgcs
    keep = %w[
      boost coredumper duktape jwt-cpp libbacktrace libcno
      libkmip lz4 opensslpp rapidjson unordered_dense xxhash
    ]
    (buildpath/"extra").each_child { |dir| rm_r(dir) unless keep.include?(dir.basename.to_s) }

    # Find Homebrew OpenLDAP instead of the macOS framework
    inreplace "cmake/ldap.cmake", "NAMES ldap_r ldap", "NAMES ldap"

    # Disable ABI checking
    inreplace "cmake/abi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0" if OS.linux?

    icu4c = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                .to_formula
    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
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
      -DBISON_EXECUTABLE=#{formula_opt_bin("bison")}/bison
      -DWITH_ICU=#{icu4c.opt_prefix}
      -DWITH_SYSTEM_LIBS=ON
      -DWITH_EDITLINE=system
      -DWITH_FIDO=system
      -DWITH_LZ4=system
      -DWITH_PROTOBUF=system
      -DWITH_SSL=system
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
      -DWITH_UNIT_TESTS=OFF
      -DROCKSDB_BUILD_ARCH=#{ENV.effective_arch}
      -DALLOW_NO_ARMV81A_CRYPTO=ON
      -DALLOW_NO_SSE42=ON
    ]
    args << "-DROCKSDB_DISABLE_AVX2=ON" if build.bottle?
    args << "-DWITH_KERBEROS=system" unless OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    cd prefix/"mysql-test" do
      test_args = ["--vardir=#{buildpath}/mysql-test-vardir"]
      # For Linux, disable failing on warning: "Setting thread 31563 nice to 0 failed"
      # Docker containers lack CAP_SYS_NICE capability by default.
      test_args << "--nowarnings" if OS.linux?
      system "./mysql-test-run.pl", "check", *test_args
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
    if_path_exists "/etc/{my.cnf,mysql/my.cnf}" do
      warn "A system my.cnf may interfere with a Homebrew-built server starting correctly."
    end
    init_data_dir "mysql", using: :mysql, base: :var
  end

  def caveats
    <<~EOS
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
