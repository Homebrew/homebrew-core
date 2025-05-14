class Mysql < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https://dev.mysql.com/doc/refman/9.3/en/"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-9.3/mysql-9.3.0.tar.gz"
  sha256 "1a3ee236f1daac5ef897c6325c9b0e0aae486389be1b8001deb3ff77ce682d60"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    url "https://dev.mysql.com/downloads/mysql/?tpl=files&os=src"
    regex(/href=.*?mysql[._-](?:boost[._-])?v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "a1c4bcbfc9cd29ebd827d898ee23fa671d38e53fe38ed941d4de9dc5f2925bab"
    sha256 arm64_sonoma:  "a85846ee100275d3aff0e1fb367d236efe2f08b01486a4e17d95f44065a99777"
    sha256 arm64_ventura: "bbd5331e6cad86f69fd249644870e12298fb7700941c4b442766d6b39ad2efcd"
    sha256 sonoma:        "246637314ceb5efb5f4df6e8e9548523fd24bf99d2ab2249baf55c990323a083"
    sha256 ventura:       "e3485cdac165beee6846f57b678938929e2339e80fa83f1f16f152130c1f46b1"
    sha256 arm64_linux:   "6b3feff6a22a3dc3ebc0b52aa20be21de6c15c4508236e6c2c718c6630f235b0"
    sha256 x86_64_linux:  "4f4f12f8b6e178121b92995ed4a3153dca966f6c304fc74765066761aa86a56e"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "icu4c@77"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "protobuf@29"
  depends_on "zlib" # Zlib 1.2.13+
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "libedit"

  on_ventura :or_older do
    depends_on "llvm"
    # back out commit: Bug#37065301 Silence warnings on macOS
    patch <<~EOF
      diff --git a/cmake/component.cmake b/cmake/component.cmake
      index a77fa0f..e476381 100644
      --- a/cmake/component.cmake
      +++ b/cmake/component.cmake
      @@ -98,10 +98,6 @@ MACRO(MYSQL_ADD_COMPONENT component_arg)
           # For APPLE: adjust path dependecy for SSL shared libraries.
           SET_PATH_TO_CUSTOM_SSL_FOR_APPLE(${target})

      -    IF(APPLE)
      -      TARGET_LINK_OPTIONS(${target} PRIVATE LINKER:-no_warn_duplicate_libraries)
      -    ENDIF()
      -
           IF(WIN32_CLANG AND WITH_ASAN)
             TARGET_LINK_LIBRARIES(${target}
               "${ASAN_LIB_DIR}/clang_rt.asan_dll_thunk-x86_64.lib")
      diff --git a/cmake/libutils.cmake b/cmake/libutils.cmake
      index 69adcdb..661171b 100644
      --- a/cmake/libutils.cmake
      +++ b/cmake/libutils.cmake
      @@ -358,7 +358,6 @@ MACRO(MERGE_LIBRARIES_SHARED TARGET_ARG)

         IF(APPLE)
           SET_TARGET_PROPERTIES(${TARGET} PROPERTIES MACOSX_RPATH ON)
      -    TARGET_LINK_OPTIONS(${TARGET} PRIVATE LINKER:-no_warn_duplicate_libraries)
         ENDIF()

         TARGET_LINK_OPTIONS(${TARGET} PRIVATE ${export_link_flags})
      @@ -703,10 +702,6 @@ FUNCTION(ADD_SHARED_LIBRARY TARGET_ARG)
           ENDIF()
         ENDIF()

      -  IF(APPLE)
      -    TARGET_LINK_OPTIONS(${TARGET} PRIVATE LINKER:-no_warn_duplicate_libraries)
      -  ENDIF()
      -
         ADD_OBJDUMP_TARGET(show_${TARGET} "$<TARGET_FILE:${TARGET}>"
           DEPENDS ${TARGET})

      diff --git a/cmake/mysql_add_executable.cmake b/cmake/mysql_add_executable.cmake
      index 2a0548b..232e78a 100644
      --- a/cmake/mysql_add_executable.cmake
      +++ b/cmake/mysql_add_executable.cmake
      @@ -212,10 +212,6 @@ FUNCTION(MYSQL_ADD_EXECUTABLE target_arg)
           MACOS_ADD_DEVELOPER_ENTITLEMENTS(${target})
         ENDIF()

      -  IF(APPLE)
      -    TARGET_LINK_OPTIONS(${target} PRIVATE LINKER:-no_warn_duplicate_libraries)
      -  ENDIF()
      -
         IF(WIN32_CLANG AND WITH_ASAN)
           TARGET_LINK_LIBRARIES(${target}
             "${ASAN_LIB_DIR}/clang_rt.asan-x86_64.lib"
      diff --git a/cmake/plugin.cmake b/cmake/plugin.cmake
      index a7727ef..eac9d74 100644
      --- a/cmake/plugin.cmake
      +++ b/cmake/plugin.cmake
      @@ -327,10 +327,6 @@ MACRO(MYSQL_ADD_PLUGIN plugin_arg)
             DEPENDS ${target})
         ENDIF()

      -  IF(BUILD_PLUGIN AND ARG_MODULE_ONLY AND APPLE)
      -    TARGET_LINK_OPTIONS(${target} PRIVATE LINKER:-no_warn_duplicate_libraries)
      -  ENDIF()
      -
         IF(BUILD_PLUGIN)
           ADD_DEPENDENCIES(plugin_all ${target})
           TARGET_COMPILE_FEATURES(${target} PUBLIC cxx_std_20)
      diff --git a/extra/libcno/CMakeLists.txt b/extra/libcno/CMakeLists.txt
      index e2513f4..1577bab 100644
      --- a/extra/libcno/CMakeLists.txt
      +++ b/extra/libcno/CMakeLists.txt
      @@ -16,10 +16,6 @@ SET(LIBCNO_GENERATE_DIR "${CMAKE_CURRENT_BINARY_DIR}")

       DISABLE_MISSING_PROFILE_WARNING()

      -IF(APPLE_XCODE)
      -  STRING_APPEND(CMAKE_C_FLAGS " -Wno-shorten-64-to-32")
      -ENDIF()
      -
       # Following targets were created to mimic behavior of following
       # files supplied by libcno:
       #
      diff --git a/extra/protobuf/protobuf-24.4/cmake/libprotobuf-lite.cmake b/extra/protobuf/protobuf-24.4/cmake/libprotobuf-lite.cmake
      index f601e7f..b2826db 100644
      --- a/extra/protobuf/protobuf-24.4/cmake/libprotobuf-lite.cmake
      +++ b/extra/protobuf/protobuf-24.4/cmake/libprotobuf-lite.cmake
      @@ -57,11 +57,6 @@ IF(protobuf_BUILD_SHARED_LIBS)
           RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/library_output_directory
           )

      -  IF(APPLE)
      -    TARGET_LINK_OPTIONS(libprotobuf-lite
      -      PRIVATE LINKER:-no_warn_duplicate_libraries)
      -  ENDIF()
      -
         IF(WIN32)
           ADD_CUSTOM_COMMAND(TARGET libprotobuf-lite POST_BUILD
             COMMAND ${CMAKE_COMMAND} -E copy_if_different
      diff --git a/extra/protobuf/protobuf-24.4/cmake/libprotobuf.cmake b/extra/protobuf/protobuf-24.4/cmake/libprotobuf.cmake
      index 81428fb..ceb557f 100644
      --- a/extra/protobuf/protobuf-24.4/cmake/libprotobuf.cmake
      +++ b/extra/protobuf/protobuf-24.4/cmake/libprotobuf.cmake
      @@ -61,10 +61,6 @@ IF(protobuf_BUILD_SHARED_LIBS)
           RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/library_output_directory
           )

      -  IF(APPLE)
      -    TARGET_LINK_OPTIONS(libprotobuf PRIVATE LINKER:-no_warn_duplicate_libraries)
      -  ENDIF()
      -
         IF(WIN32)
           ADD_CUSTOM_COMMAND(TARGET libprotobuf POST_BUILD
             COMMAND ${CMAKE_COMMAND} -E copy_if_different
      diff --git a/extra/protobuf/protobuf-24.4/cmake/libprotoc.cmake b/extra/protobuf/protobuf-24.4/cmake/libprotoc.cmake
      index ef63037..7ba5394 100644
      --- a/extra/protobuf/protobuf-24.4/cmake/libprotoc.cmake
      +++ b/extra/protobuf/protobuf-24.4/cmake/libprotoc.cmake
      @@ -53,9 +53,6 @@ IF(protobuf_BUILD_SHARED_LIBS)
           DEBUG_POSTFIX ""
           LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/library_output_directory
           RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/library_output_directory)
      -  IF(APPLE)
      -    TARGET_LINK_OPTIONS(libprotoc PRIVATE LINKER:-no_warn_duplicate_libraries)
      -  ENDIF()
         IF(WIN32)
           ADD_CUSTOM_COMMAND(TARGET libprotoc POST_BUILD
             COMMAND ${CMAKE_COMMAND} -E copy_if_different
      diff --git a/extra/protobuf/protobuf-24.4/cmake/protoc.cmake b/extra/protobuf/protobuf-24.4/cmake/protoc.cmake
      index 215eb21..70f1b60 100644
      --- a/extra/protobuf/protobuf-24.4/cmake/protoc.cmake
      +++ b/extra/protobuf/protobuf-24.4/cmake/protoc.cmake
      @@ -15,10 +15,6 @@ set_target_properties(protoc PROPERTIES

       ################################################################

      -IF(APPLE)
      -  TARGET_LINK_OPTIONS(protoc PRIVATE LINKER:-no_warn_duplicate_libraries)
      -ENDIF()
      -
       SET_TARGET_PROPERTIES(protoc PROPERTIES
         RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/runtime_output_directory)

      diff --git a/router/cmake/Plugin.cmake b/router/cmake/Plugin.cmake
      index ac6b6b2..9b4afc5 100644
      --- a/router/cmake/Plugin.cmake
      +++ b/router/cmake/Plugin.cmake
      @@ -89,9 +89,6 @@ FUNCTION(add_harness_plugin NAME)
         # .dylib, which we do not want, so we reset it here.
         ADD_LIBRARY(${NAME} SHARED ${_option_SOURCES})
         TARGET_COMPILE_FEATURES(${NAME} PUBLIC cxx_std_20)
      -  IF(APPLE)
      -    TARGET_LINK_OPTIONS(${NAME} PRIVATE LINKER:-no_warn_duplicate_libraries)
      -  ENDIF()

         # add plugin to build-all target
         ADD_DEPENDENCIES(mysqlrouter_all ${NAME})
    EOF

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
    keep = %w[boost duktape libbacktrace libcno lz4 rapidjson unordered_dense xxhash]
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
