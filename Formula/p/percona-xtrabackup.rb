class PerconaXtrabackup < Formula
  desc "Open source hot backup tool for InnoDB and XtraDB databases"
  homepage "https://www.percona.com/software/mysql-database/percona-xtrabackup"
  url "https://downloads.percona.com/downloads/Percona-XtraBackup-8.4/Percona-XtraBackup-8.4.0-4/source/tarball/percona-xtrabackup-8.4.0-4.tar.gz"
  sha256 "e566a164a21b18781aad281b84426418ac2bcf71052ec85d8c5e62f742a7dfeb"
  license "GPL-2.0-only"
  revision 4

  livecheck do
    url "https://www.percona.com/products-api.php", post_form: {
      version: "Percona-XtraBackup-#{version.major_minor}",
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

  bottle do
    sha256 arm64_tahoe:   "63dfd7a4b5b458d0ba8cf09b4148f8f8a470ab3c00a7a83dca13128b8eeb8591"
    sha256 arm64_sequoia: "e87ba8266054512e560e86da6b19e135bf9c2a82d5dee652a09b948f017c6255"
    sha256 arm64_sonoma:  "c41538aee9b7ff1332cbbd14549fd49462e1481c3eded16b4df2215228e7cb7d"
    sha256 sonoma:        "b8e2134a1922fe4b6032303bcbd382e54c9cef5ffeb80c44862ce3568203aebe"
    sha256 arm64_linux:   "59998f7b305740e735a62dc7ba534f65a53df8ca329df9cbaaf3d66443fe27f0"
    sha256 x86_64_linux:  "f9b2887a142203c7e138ec1f8c183882daa8c74754112d7615c160447e933210"
  end

  depends_on "bison" => :build # needs bison >= 3.0.4
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "mysql@8.4" => :test
  depends_on "icu4c@78"
  depends_on "libev"
  depends_on "libgcrypt"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "zlib"
  depends_on "zstd"

  uses_from_macos "cyrus-sasl" => :build
  uses_from_macos "libedit" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "libaio"
    depends_on "procps"
  end

  # Apply fix for newer protobuf from MySQL repo. Remove once Percona syncs with MySQL 8.0.40 / 8.4.3
  patch do
    url "https://github.com/mysql/mysql-server/commit/941e4ac8cfdacc7c2cd1c11b4d72329b70c46564.patch?full_index=1"
    sha256 "1c39061a6c90e25a542f547ff8e5463d84c446009b4ab317c2c52184a4f931b8"
  end

  # FreeBSD patches to fix build with newer Clang
  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-libs_mysql_serialization_archive.h"
    sha256 "d0e2cf2c2b4c71fc905a6a88936c7c9d6750b624c57c86ead7a73bbc1fd659c8"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-libs_mysql_serialization_serializer__default__impl.hpp"
    sha256 "62293818c44f0a97a3233e4ab3d82d9abcc826c57981aa40acecdcd92dd6a934"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-libs_mysql_serialization_serializer__impl.hpp"
    sha256 "91b0a8381c00600695110c8ec90488a22fa0c211cbe304eca44de7602f3a097b"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-sql_binlog__ostream.cc"
    sha256 "5bbb82ff9d9594ce1c19d34c83e22b088684057fca7c4357a0ba43dcb1ede0fc"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-sql_mdl__context__backup.cc"
    sha256 "557db2bb30ff8a985f8b4d016b1e2909b7127ea77fdcd2f7611fd66dcea58e4f"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-sql_mdl__context__backup.h"
    sha256 "1352f0290fb3acb031f743bdb72d8483c42f47ba2e0d08a33617a280c2f6771f"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-sql_range__optimizer_index__range__scan__plan.cc"
    sha256 "8ca65706fd386d2837c0a32a763553a24a248d8ffb518176627bdf735fcbfa9d"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-sql_rpl__log__encryption.cc"
    sha256 "f5e993a1b56ae86f3c63ea75799493c875d6a08c81f319fede707bbe16a2e59f"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-sql_stream__cipher.cc"
    sha256 "ac74c60f6051223993c88e7a11ddd9512c951ac1401d719a2c3377efe1bee3cf"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-sql_stream__cipher.h"
    sha256 "5c8646a2fdce4eb317df4f77cb582705a44e0c61485cc6c268f808e25da682b3"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-unittest_gunit_binlogevents_transaction__compression-t.cc"
    sha256 "b0f7eb7524a5115bf7eaa0fdd928d1db18a274547adf8cfc8003da97fcf82b8f"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-unittest_gunit_stream__cipher-t.cc"
    sha256 "fe23c4098e1b8c5113486800e37bb74683be0b7dd61a9608603428f395588e96"
  end

  # Patch out check for Homebrew `boost`.
  # This should not be necessary when building inside `brew`.
  # https://github.com/Homebrew/homebrew-test-bot/pull/820
  #
  # Also, add a few fixes not covered in the FreeBSD patches.
  # These fixes are analogous to the changes made by the FreeBSD patches.
  patch :DATA

  def install
    # Remove bundled libraries other than explicitly allowed below.
    # `boost` and `rapidjson` must use bundled copy due to patches.
    # `lz4` is still needed due to xxhash.c used by mysqlgcs
    keep = %w[boost libbacktrace libcno libkmip lz4 rapidjson unordered_dense]
    (buildpath/"extra").each_child { |dir| rm_r(dir) unless keep.include?(dir.basename.to_s) }

    # Disable ABI checking
    inreplace "cmake/abi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0" if OS.linux?

    icu4c = deps.map(&:to_formula).find { |f| f.name.match?(/^icu4c@\d+$/) }
    # -DWITH_FIDO=system isn't set as feature isn't enabled and bundled copy was removed.
    # Formula paths are set to avoid HOMEBREW_HOME logic in CMake scripts
    cmake_args = %W[
      -DBUILD_CONFIG=xtrabackup_release
      -DCOMPILATION_COMMENT=Homebrew
      -DINSTALL_PLUGINDIR=lib/percona-xtrabackup/plugin
      -DINSTALL_MANDIR=#{man}
      -DWITH_MAN_PAGES=ON
      -DINSTALL_MYSQLTESTDIR=
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
    ]
    # Reduce overlinking on macOS
    cmake_args += %w[EXE MODULE].map { |type| "-DCMAKE_#{type}_LINKER_FLAGS=-Wl,-dead_strip_dylibs" } if OS.mac?

    # Remove conflicting manpages
    rm (Dir["man/*"] - ["man/CMakeLists.txt"])

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # remove conflicting library that is already installed by mysql
    (lib/"libmysqlservices.a").unlink
    # remove conflicting libraries/headers that are installed by percona-server
    (lib/"libkmip.a").unlink
    (lib/"libkmippp.a").unlink
    (include/"kmip.h").unlink
    (include/"kmippp.h").unlink
  end

  test do
    mysql = Formula["mysql@8.4"]
    common_args = %W[--no-defaults --port=#{free_port} --socket=#{testpath}/mysql.sock]
    client_args = %w[--user=root --password=]
    server_args = %W[--datadir=#{testpath}/mysql --tmpdir=#{testpath}/tmp]
    mysqld_args = common_args + server_args + %W[--mysqlx=OFF --user=#{ENV["USER"]}]
    mysqladmin_args = common_args + client_args
    xtrabackup_args = common_args + client_args + server_args + %W[--target-dir=#{testpath}/backup --backup]

    (testpath/"backup").mkpath
    (testpath/"mysql").mkpath
    (testpath/"tmp").mkpath

    assert_match version.to_s, shell_output("#{bin}/xtrabackup --version 2>&1")

    output = shell_output("#{bin}/xtrabackup #{xtrabackup_args.join(" ")} 2>&1", 1)
    assert_match "Failed to connect to MySQL server", output

    system mysql.bin/"mysqld", *mysqld_args, "--initialize-insecure"
    pid = spawn(mysql.bin/"mysqld", *mysqld_args)
    begin
      sleep 5
      output = shell_output("#{bin}/xtrabackup #{xtrabackup_args.join(" ")} 2>&1")
      refute_match "[ERROR]", output
      assert_match "[Xtrabackup] completed OK!", output
      assert_path_exists testpath/"backup/xtrabackup_info"
    ensure
      system mysql.bin/"mysqladmin", *mysqladmin_args, "shutdown"
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
diff --git i/sql/rpl_log_encryption.cc w/sql/rpl_log_encryption.cc
index 862e769c..d761bd7f 100644
--- i/sql/rpl_log_encryption.cc
+++ w/sql/rpl_log_encryption.cc
@@ -213,7 +213,7 @@ bool Rpl_encryption::recover_master_key() {
         Rpl_encryption_header::seqno_to_key_id(m_master_key_seqno);
     auto master_key =
         get_key(m_master_key.m_id, Rpl_encryption_header::get_key_type());
-    m_master_key.m_value.assign(master_key.second);
+    m_master_key.m_value = master_key.second;
     /* No keyring error */
     if (master_key.first == Keyring_status::KEYRING_ERROR_FETCHING) goto err1;
   }
diff --git i/storage/innobase/xtrabackup/src/keyring_plugins.cc w/storage/innobase/xtrabackup/src/keyring_plugins.cc
index 6d169078..3247f95d 100644
--- i/storage/innobase/xtrabackup/src/keyring_plugins.cc
+++ w/storage/innobase/xtrabackup/src/keyring_plugins.cc
@@ -863,7 +863,7 @@ bool xb_binlog_password_reencrypt(const char *binlog_file_path) {
     return (false);
   }
 
-  Key_string file_password(key, Encryption::KEY_LEN);
+  Key_string file_password(key, key + Encryption::KEY_LEN);
   header->encrypt_file_password(file_password);
 
   IO_CACHE_ostream ostream;
