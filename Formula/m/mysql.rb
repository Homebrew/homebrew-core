class Mysql < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https://dev.mysql.com/doc/refman/9.2/en/"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-9.2/mysql-9.2.0.tar.gz"
  sha256 "a39d11fdf6cf8d1b03b708d537a9132de4b99a9eb4d610293937f0687cd37a12"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }
  revision 1

  livecheck do
    url "https://dev.mysql.com/downloads/mysql/?tpl=files&os=src"
    regex(/href=.*?mysql[._-](?:boost[._-])?v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "fc77970b627f9277451244f990caa84334909a1cf7d1b0a6b7ee8bd00cd7c39f"
    sha256 arm64_sonoma:  "7e2a598b6208eb28a96beec0a9036511fb764c1775e0b2b80d8ef9422b421f97"
    sha256 arm64_ventura: "ef6532392f0d4a5f3defa050f6bdc70424f9b627ac95d78988f56d09e31ac48e"
    sha256 sonoma:        "471e6e241aea5cfdfbd09bcb9dcc2f38d2314e227b10f67cbbb03fa7851c440a"
    sha256 ventura:       "eb0bb231b64188a8986a08167ce49106781364740a824e16ab577be1c2704970"
    sha256 x86_64_linux:  "2337362a5f0ed0d0512702af5027e8c7a4083872264b8ef60cef18c2fe3ea2cb"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "icu4c@76"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "zlib" # Zlib 1.2.13+
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
    version "9"
    cause "Requires C++20"
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
    keep = %w[boost duktape libbacktrace libcno lz4 rapidjson unordered_dense]
    (buildpath/"extra").each_child { |dir| rm_r(dir) unless keep.include?(dir.basename.to_s) }

    if OS.linux?
      # Disable ABI checking
      inreplace "cmake/abi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0"
    elsif MacOS.version <= :ventura
      ENV.llvm_clang
      ENV.append "LDFLAGS", "-L#{Formula["llvm"].opt_lib}/unwind -lunwind"
      # When using Homebrew's superenv shims, we need to use HOMEBREW_LIBRARY_PATHS
      # rather than LDFLAGS for libc++ in order to correctly link to LLVM's libc++.
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib/"c++"
    end

    icu4c = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                .to_formula
    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    # -DWITH_FIDO=system isn't set as feature isn't enabled and bundled copy was removed.
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
      -DBISON_EXECUTABLE=#{Formula["bison"].opt_bin}/bison
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DWITH_ICU=#{icu4c.opt_prefix}
      -DWITH_SYSTEM_LIBS=ON
      -DWITH_EDITLINE=system
      -DWITH_LZ4=system
      -DWITH_PROTOBUF=system
      -DWITH_SSL=system
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
      -DWITH_UNIT_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    cd prefix/"mysql-test" do
      system "./mysql-test-run.pl", "status", "--vardir=#{buildpath}/mysql-test-vardir"
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

    # Don't initialize database, it clashes when testing other MySQL-like implementations.
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    unless (datadir/"mysql/general_log.CSM").exist?
      ENV["TMPDIR"] = nil
      system bin/"mysqld", "--initialize-insecure", "--user=#{ENV["USER"]}",
                           "--basedir=#{prefix}", "--datadir=#{datadir}", "--tmpdir=/tmp"
    end
  end

  def caveats
    s = <<~EOS
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
    if (my_cnf = ["/etc/my.cnf", "/etc/mysql/my.cnf"].find { |x| File.exist? x })
      s += <<~EOS

        A "#{my_cnf}" from another install may interfere with a Homebrew-built
        server starting up correctly.
      EOS
    end
    s
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
