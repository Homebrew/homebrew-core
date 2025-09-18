class PerconaServer < Formula
  desc "Drop-in MySQL replacement"
  homepage "https://www.percona.com"
  url "https://downloads.percona.com/downloads/Percona-Server-8.4/Percona-Server-8.4.5-5/source/tarball/percona-server-8.4.5-5.tar.gz"
  sha256 "8b47ff35dc2a6e7eaacaa2d204ae456c15b5d9953360ccb6250da8d68d98f6af"
  license "BSD-3-Clause"
  revision 3

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
    sha256 arm64_tahoe:   "582d071a36ce9c1714fe86424e15f3327e303631973328b5de928f435c29429c"
    sha256 arm64_sequoia: "f6ed1470764a5f4c2c35c75645e5973a70fb635869d4f6a5e37bbb5d1462189e"
    sha256 arm64_sonoma:  "3d4e18727d53f9877a0662a85333c6dd500c770d1b42760c234e0bac1f18d341"
    sha256 arm64_ventura: "d112772509e37b51d03ba890899640de02902a90ff014ccd02467652bf468a54"
    sha256 sonoma:        "4396cbcc2d0bda652aa8f913ca9d147ac8b18e34599c1b9bbc36aced61f50e57"
    sha256 ventura:       "7defc69680022ebea072f81935216490e70057806f9b05cf1bd34f7c11d63aed"
    sha256 arm64_linux:   "7505c847acb81be96ee42ffc05115b7c1c0583a3bcb2b8d71a655828111a1250"
    sha256 x86_64_linux:  "55cf743c8bd6892ad6c0ef4f30f7ed25027ffec0b0d7d7702e4fa1a0a08443c0"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "icu4c@77"
  depends_on "libfido2"
  depends_on "lz4"
  depends_on "openldap" # Needs `ldap_set_urllist_proc`, not provided by LDAP.framework
  depends_on "openssl@3"
  depends_on "protobuf@29"
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

  # FreeBSD patches to fix build with newer Clang
  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/86108d2ca4d7d22224b1a4161004c3bf292db0a2/databases/mysql84-server/files/patch-libs_mysql_serialization_serializer__default__impl.hpp"
    sha256 "82706b5160fe3397ddfbeebeb24e2d1558cd54776b852b3277c94420e47c9ff4"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/86108d2ca4d7d22224b1a4161004c3bf292db0a2/databases/mysql84-server/files/patch-libs_mysql_serialization_serializer__impl.hpp"
    sha256 "17c23e64fdb0481959812cc3aec0f5165372753d63266bd388a93d45c55902e0"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/86108d2ca4d7d22224b1a4161004c3bf292db0a2/databases/mysql84-server/files/patch-sql_binlog__ostream.cc"
    sha256 "5bbb82ff9d9594ce1c19d34c83e22b088684057fca7c4357a0ba43dcb1ede0fc"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/86108d2ca4d7d22224b1a4161004c3bf292db0a2/databases/mysql84-server/files/patch-sql_mdl__context__backup.cc"
    sha256 "557db2bb30ff8a985f8b4d016b1e2909b7127ea77fdcd2f7611fd66dcea58e4f"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/86108d2ca4d7d22224b1a4161004c3bf292db0a2/databases/mysql84-server/files/patch-sql_rpl__log__encryption.cc"
    sha256 "f5e993a1b56ae86f3c63ea75799493c875d6a08c81f319fede707bbe16a2e59f"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/86108d2ca4d7d22224b1a4161004c3bf292db0a2/databases/mysql84-server/files/patch-sql_stream__cipher.cc"
    sha256 "ac74c60f6051223993c88e7a11ddd9512c951ac1401d719a2c3377efe1bee3cf"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/86108d2ca4d7d22224b1a4161004c3bf292db0a2/databases/mysql84-server/files/patch-unittest_gunit_stream__cipher-t.cc"
    sha256 "fe23c4098e1b8c5113486800e37bb74683be0b7dd61a9608603428f395588e96"
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
