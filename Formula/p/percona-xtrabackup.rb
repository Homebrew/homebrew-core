class PerconaXtrabackup < Formula
  desc "Open source hot backup tool for InnoDB and XtraDB databases"
  homepage "https://www.percona.com/software/mysql-database/percona-xtrabackup"
  url "https://downloads.percona.com/downloads/Percona-XtraBackup-8.4/Percona-XtraBackup-8.4.0-6/source/tarball/percona-xtrabackup-8.4.0-6.tar.gz"
  sha256 "e0e886b78d18b34122bd15b2d80f52fc5df2422260edaa3074820902beecd351"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.percona.com/wp-admin/admin-ajax.php", post_form: {
      action:     "percona_downloads",
      product_id: "Percona-XtraBackup-#{version.major_minor}",
    }
    regex(/^Percona-XtraBackup-v?(\d+(?:[.-]\d+)+)$/i)
    strategy :json do |json, regex|
      json.dig("data", "versions")&.filter_map do |version|
        # Convert a version like 1.2.3-4.0 to 1.2.3-4 (but leave a version like
        # 1.2.3-4.5 as-is).
        version[regex, 1]&.sub(/(-\d+)\.0$/, '\1')
      end
    end
  end

  bottle do
    sha256 arm64_tahoe:   "8d1648808974f70924f16a95328468441bbdacd830b1554ffe6f33291a035bad"
    sha256 arm64_sequoia: "01a75c71fdcc4db6043442076a887508f21bfa45a72e73c62019d31e1e5f032b"
    sha256 arm64_sonoma:  "1ac86189566d6f85760bfe4d74d79e3b098fabb76b1e83daafb8053710064005"
    sha256 sonoma:        "c6d16f65abd9651ac7c797a577f992b54d1a2d0f5c86ecd12f2a99a6158cbb8a"
    sha256 arm64_linux:   "40689bd142a465a7d68f108732425b72780b59230c3ab624eb494987ffb280b7"
    sha256 x86_64_linux:  "ba0e07f79a2294bb3b7b7538e91bca2f1208791b31481bb11f76749050abb2ad"
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
  depends_on "zlib-ng-compat" # Zlib 1.2.13+
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
    type :backport
    resolves "https://bugs.mysql.com/bug.php?id=36678092"
  end

  # FreeBSD patches to fix build with newer Clang
  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-libs_mysql_serialization_archive.h"
    sha256 "d0e2cf2c2b4c71fc905a6a88936c7c9d6750b624c57c86ead7a73bbc1fd659c8"
    type :unofficial
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-libs_mysql_serialization_serializer__default__impl.hpp"
    sha256 "62293818c44f0a97a3233e4ab3d82d9abcc826c57981aa40acecdcd92dd6a934"
    type :unofficial
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-libs_mysql_serialization_serializer__impl.hpp"
    sha256 "91b0a8381c00600695110c8ec90488a22fa0c211cbe304eca44de7602f3a097b"
    type :unofficial
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-sql_binlog__ostream.cc"
    sha256 "5bbb82ff9d9594ce1c19d34c83e22b088684057fca7c4357a0ba43dcb1ede0fc"
    type :unofficial
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-sql_mdl__context__backup.cc"
    sha256 "557db2bb30ff8a985f8b4d016b1e2909b7127ea77fdcd2f7611fd66dcea58e4f"
    type :unofficial
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-sql_mdl__context__backup.h"
    sha256 "1352f0290fb3acb031f743bdb72d8483c42f47ba2e0d08a33617a280c2f6771f"
    type :unofficial
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-sql_range__optimizer_index__range__scan__plan.cc"
    sha256 "8ca65706fd386d2837c0a32a763553a24a248d8ffb518176627bdf735fcbfa9d"
    type :unofficial
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-sql_rpl__log__encryption.cc"
    sha256 "f5e993a1b56ae86f3c63ea75799493c875d6a08c81f319fede707bbe16a2e59f"
    type :unofficial
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-sql_stream__cipher.cc"
    sha256 "ac74c60f6051223993c88e7a11ddd9512c951ac1401d719a2c3377efe1bee3cf"
    type :unofficial
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-sql_stream__cipher.h"
    sha256 "5c8646a2fdce4eb317df4f77cb582705a44e0c61485cc6c268f808e25da682b3"
    type :unofficial
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-unittest_gunit_binlogevents_transaction__compression-t.cc"
    sha256 "b0f7eb7524a5115bf7eaa0fdd928d1db18a274547adf8cfc8003da97fcf82b8f"
    type :unofficial
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/9832739877772d46b4affedf9f796d6e70be4254/databases/mysql84-server/files/patch-unittest_gunit_stream__cipher-t.cc"
    sha256 "fe23c4098e1b8c5113486800e37bb74683be0b7dd61a9608603428f395588e96"
    type :unofficial
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
      -DBISON_EXECUTABLE=#{formula_opt_bin("bison")}/bison
      -DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@3")}
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
