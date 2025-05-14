class MysqlClient < Formula
  desc "Open source relational database management system"
  # FIXME: Actual homepage fails audit due to Homebrew's user-agent
  # homepage "https://dev.mysql.com/doc/refman/9.3/en/"
  homepage "https://github.com/mysql/mysql-server"
  url "https://cdn.mysql.com/Downloads/MySQL-9.3/mysql-9.3.0.tar.gz"
  sha256 "1a3ee236f1daac5ef897c6325c9b0e0aae486389be1b8001deb3ff77ce682d60"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql"
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "975fd82ddc975521c79adc5b8d91c8fe739e2d4b4f2f7716bb52dfaad32cd8cb"
    sha256 arm64_sonoma:  "b0f29c9fbf56dd9f36ba0518e6a08fcedd7cf39884a2828a34e3c1b69cf5ac5d"
    sha256 arm64_ventura: "20d77f2b858872d0fdfdddc552d0f0c513bdc4e939bfe43eea57a6b47fb7070d"
    sha256 sonoma:        "418c9c100877a4dae7dd49b6e78c1aafb0db23bcddbf94e522e39a78c8130398"
    sha256 ventura:       "3529c333d6cc9ca4925f0297a4ed70cf5d41bbcdb3d45dfee4a81bd16b56a8e7"
    sha256 arm64_linux:   "b7cb2de7878be31f6896f08617393a83d836620192ad20649361c101a48b591f"
    sha256 x86_64_linux:  "b19afb43de7e7a05235af8abbabec78a12fddac8278079d449cda6824683205e"
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libfido2"
  # GCC is not supported either, so exclude for El Capitan.
  depends_on macos: :sierra if DevelopmentTools.clang_build_version < 900
  depends_on "openssl@3"
  depends_on "zlib" # Zlib 1.2.13+
  depends_on "zstd"

  uses_from_macos "libedit"

  on_ventura :or_older do
    depends_on "llvm" => :build
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
    depends_on "libtirpc" => :build
    depends_on "krb5"
  end

  fails_with :gcc do
    version "9"
    cause "Requires C++20"
  end

  # Patch out check for Homebrew `boost`.
  # This should not be necessary when building inside `brew`.
  # https://github.com/Homebrew/homebrew-test-bot/pull/820
  patch :DATA

  def install
    if OS.linux?
      # Disable ABI checking
      inreplace "cmake/abi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0"
    elsif MacOS.version <= :ventura
      ENV.llvm_clang
    end

    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DCOMPILATION_COMMENT=Homebrew
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MANDIR=share/man
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DWITH_AUTHENTICATION_CLIENT_PLUGINS=yes
      -DWITH_EDITLINE=system
      -DWITH_FIDO=system
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
      -DWITH_SSL=yes
      -DWITH_UNIT_TESTS=OFF
      -DWITHOUT_SERVER=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
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
