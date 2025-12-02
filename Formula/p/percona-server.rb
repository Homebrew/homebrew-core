class PerconaServer < Formula
  desc "Drop-in MySQL replacement"
  homepage "https://www.percona.com"
  url "https://downloads.percona.com/downloads/Percona-Server-8.4/Percona-Server-8.4.6-6/source/tarball/percona-server-8.4.6-6.tar.gz"
  sha256 "ab4d64fbf4f3bd3ee1e766ea9fd89c73a54c96b5148cc0cd2b3d14753c805a35"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url "https://www.percona.com/products-api.php", post_form: {
      version: "Percona-Server-#{version.major_minor}",
    }
    regex(/value=["']?[^"' >]*?v?(\d+(?:[.-]\d+)+)[|"' >]/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map do |match|
        # Convert a version like 1.2.3-4.0 to 1.2.3-4 (but leave a version like
        # 1.2.3-4.5 as-is).
        match[0].sub(/(-\d+)\.0$/, '\1')
      end
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "be52b0a7c4d0edc70381549dc0f90f5b28f4663d2d93736f576234a35c2c6dfc"
    sha256 arm64_sequoia: "fa1806e797e82c9b21b542d293b72f2c749424674bbeddcb6e020f6b10cb9bb9"
    sha256 arm64_sonoma:  "066b74216402f9738295363923686cfa52fd9587294bded316724834d6d605c7"
    sha256 sonoma:        "d815cb000c93fdefe825b54589b6d90a715d2d496a6b4c9839507d84c1ba2f6b"
    sha256 arm64_linux:   "f372217852729a01111d112fd83a6f1532bf1f05f48c486cb04f395732ee327c"
    sha256 x86_64_linux:  "b81dff9b6083841fa9a69794ab7a38c46fa02bbed911836772dc840f235ad740"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "icu4c@78"
  depends_on "libfido2"
  depends_on "lz4"
  depends_on "openldap" # Needs `ldap_set_urllist_proc`, not provided by LDAP.framework
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "zlib" # Zlib 1.2.13+
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"
  uses_from_macos "libedit"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "libtirpc"
  end

  conflicts_with "mariadb", "mysql", because: "percona, mariadb, and mysql install the same binaries"

  # https://github.com/percona/percona-server/blob/8.4/cmake/os/Linux.cmake
  fails_with :gcc do
    version "9"
    cause "Requires GCC 10 or newer"
  end

  # Apply MySQL commit to support Protobuf >= 30
  patch do
    url "https://github.com/mysql/mysql-server/commit/4c1fdd1fb34a9a80a062357a54afe134a92f8abc.patch?full_index=1"
    sha256 "8943cf092d31f2ed788f9a86b11b27973ec310d53718f15f6d2dac618696e1a3"
  end

  # Patch out check for Homebrew `boost`.
  # This should not be necessary when building inside `brew`.
  # https://github.com/Homebrew/homebrew-test-bot/pull/820
  patch :DATA

  def datadir
    var/"mysql"
  end

  def install
    # Remove bundled libraries other than explicitly allowed below.
    # `boost` and `rapidjson` must use bundled copy due to patches.
    # `lz4` is still needed due to xxhash.c used by mysqlgcs
    keep = %w[boost coredumper duktape libbacktrace libcno libkmip lz4 opensslpp rapidjson unordered_dense xxhash]
    (buildpath/"extra").each_child { |dir| rm_r(dir) unless keep.include?(dir.basename.to_s) }

    # Find Homebrew OpenLDAP instead of the macOS framework
    inreplace "cmake/ldap.cmake", "NAMES ldap_r ldap", "NAMES ldap"

    # Fix mysqlrouter_passwd RPATH to link to metadata_cache.so
    inreplace "router/src/http/src/CMakeLists.txt",
              "ADD_INSTALL_RPATH(mysqlrouter_passwd \"${ROUTER_INSTALL_RPATH}\")",
              "\\0\nADD_INSTALL_RPATH(mysqlrouter_passwd \"${RPATH_ORIGIN}/../${ROUTER_INSTALL_PLUGINDIR}\")"

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
      -DBISON_EXECUTABLE=#{Formula["bison"].opt_bin}/bison
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
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

    # Workaround for
    #  error: a template argument list is expected after a name prefixed by the template keyword
    #   84 |     return Archive_derived_type::template get_size(std::forward<Type>(arg));
    #      |                                           ^
    ENV.append_to_cflags "-Wno-missing-template-arg-list-after-template-kw" if OS.mac?

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

  def post_install
    # Make sure the var/mysql directory exists
    (var/"mysql").mkpath

    if (my_cnf = ["/etc/my.cnf", "/etc/mysql/my.cnf"].find { |x| File.exist? x })
      opoo <<~EOS
        A "#{my_cnf}" from another install may interfere with a Homebrew-built
        server starting up correctly.
      EOS
    end

    # Don't initialize database, it clashes when testing other MySQL-like implementations.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    unless (datadir/"mysql/general_log.CSM").exist?
      ENV["TMPDIR"] = nil
      system bin/"mysqld", "--initialize-insecure", "--user=#{ENV["USER"]}",
                           "--basedir=#{prefix}", "--datadir=#{datadir}", "--tmpdir=/tmp"
    end
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

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 438dff720c5..47863c17e23 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -1948,31 +1948,6 @@ MYSQL_CHECK_RAPIDJSON()
 MYSQL_CHECK_FIDO()
 MYSQL_CHECK_FIDO_DLLS()

-IF(APPLE)
-  GET_FILENAME_COMPONENT(HOMEBREW_BASE ${HOMEBREW_HOME} DIRECTORY)
-  IF(EXISTS ${HOMEBREW_BASE}/include/boost)
-    FOREACH(SYSTEM_LIB ICU LZ4 PROTOBUF ZSTD FIDO)
-      IF(WITH_${SYSTEM_LIB} STREQUAL "system")
-        MESSAGE(FATAL_ERROR
-          "WITH_${SYSTEM_LIB}=system is not compatible with Homebrew boost\n"
-          "MySQL depends on ${BOOST_PACKAGE_NAME} with a set of patches.\n"
-          "Including headers from ${HOMEBREW_BASE}/include "
-          "will break the build.\n"
-          "Please use WITH_${SYSTEM_LIB}=bundled\n"
-          "or do 'brew uninstall boost' or 'brew unlink boost'"
-          )
-      ENDIF()
-    ENDFOREACH()
-  ENDIF()
-  # Ensure that we look in /usr/local/include or /opt/homebrew/include
-  FOREACH(SYSTEM_LIB ICU LZ4 PROTOBUF ZSTD FIDO)
-    IF(WITH_${SYSTEM_LIB} STREQUAL "system")
-      INCLUDE_DIRECTORIES(SYSTEM ${HOMEBREW_BASE}/include)
-      BREAK()
-    ENDIF()
-  ENDFOREACH()
-ENDIF()
-
 IF(WITH_AUTHENTICATION_WEBAUTHN OR
   WITH_AUTHENTICATION_CLIENT_PLUGINS)
   IF(WITH_FIDO STREQUAL "system" AND
