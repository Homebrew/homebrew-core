class PerconaXtrabackupAT80 < Formula
  desc "Open source hot backup tool for InnoDB and XtraDB databases"
  homepage "https://www.percona.com/software/mysql-database/percona-xtrabackup"
  url "https://downloads.percona.com/downloads/Percona-XtraBackup-8.0/Percona-XtraBackup-8.0.35-34/source/tarball/percona-xtrabackup-8.0.35-34.tar.gz"
  sha256 "6ca81cd647e7cb1d8fd341f97cd32248bd719f9104a63eb24f1edda6a2d2441c"
  license "GPL-2.0-only"
  revision 6

  livecheck do
    url "https://www.percona.com/products-api.php", post_form: {
      version: "Percona-XtraBackup-#{version.major_minor}",
    }
    regex(/value=["']?[^"' >]*?v?(8\.0(?:[.-]\d+)+)[|"' >]/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map do |match|
        # Convert a version like 1.2.3-4.0 to 1.2.3-4 (but leave a version like
        # 1.2.3-4.5 as-is).
        match[0].sub(/(-\d+)\.0$/, '\1')
      end
    end
  end

  bottle do
    sha256 arm64_tahoe:   "b7e5aae00e7cbf8dbd645ae72ea5cd26f0c19a5c08f5bab5c85c377c35c946c2"
    sha256 arm64_sequoia: "b1de44e35fb2f9393a9c27fed982af1aad1a00d20fd8a959ebd5ee5b94780e5d"
    sha256 arm64_sonoma:  "f0d031ffab6c9062391dcf417f78ebf817237c87251708cd939c469239b119e4"
    sha256 sonoma:        "157385d3be1b9887bede1e2f593b7c74534378d08b878f951435d88d9edbc7fe"
    sha256 arm64_linux:   "10ac2f75b40ca97b7be3b1e48755fdd180faa86a73379e4decd96737bd55566a"
    sha256 x86_64_linux:  "6fa6c45d8141be533c1f35449d529acd214361ca6d912f9660a4add08f4c24b5"
  end

  keg_only :versioned_formula

  depends_on "bison" => :build # needs bison >= 3.0.4
  depends_on "cmake" => :build
  depends_on "libevent" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "mysql@8.0" => :test
  depends_on "icu4c@78"
  depends_on "libev"
  depends_on "libgcrypt"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "perl-dbd-mysql"
  depends_on "protobuf"
  depends_on "zlib"
  depends_on "zstd"

  uses_from_macos "cyrus-sasl" => :build
  uses_from_macos "libedit" => :build
  uses_from_macos "vim" => :build # needed for xxd
  uses_from_macos "curl"
  uses_from_macos "perl"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "libaio"
    depends_on "procps"
  end

  # Check boost version via `brew livecheck percona-xtrabackup@8.0 --resources --autobump`
  resource "boost" do
    url "https://downloads.sourceforge.net/project/boost/boost/1.77.0/boost_1_77_0.tar.bz2"
    sha256 "fc9f85fc030e233142908241af7a846e60630aa7388de9a5fafb1f3a26840854"

    livecheck do
      url "https://raw.githubusercontent.com/percona/percona-xtrabackup/refs/tags/percona-xtrabackup-#{LATEST_VERSION}/cmake/boost.cmake"
      regex(%r{/release/v?(\d+(?:\.\d+)+)/}i)
    end

    # Apply FreeBSD patch for building with new `clang`.
    patch :p2 do
      url "https://raw.githubusercontent.com/freebsd/freebsd-ports/58a6f3f12a0ab2a65140f588216340d49245880e/databases/mysql80-server/files/patch-boost_boost__1__77__0_boost_mpl_aux___integral__wrapper.hpp"
      sha256 "203ada9cec70fe1feb2796cb7421757d7334452dfd5168120a3e7eb79aaf529d"
    end
  end

  # Apply fix for newer protobuf from MySQL repo. Remove once Percona syncs with MySQL 8.0.40
  patch do
    url "https://github.com/mysql/mysql-server/commit/269abc0409b22bb87ec88bd4d53dfb7a1403eace.patch?full_index=1"
    sha256 "ffcee32804e7e1237907432adb3590fcbf30c625eea836df6760c05a312a84e1"
  end

  # FreeBSD patches for fixing build failure with newer clang
  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/1a02a961a2d53f21bf208f07903a97cc46f43e17/databases/mysql80-server/files/patch-sql_binlog__ostream.cc"
    sha256 "16f86edd2daf5f6c87616781c9f51f76d4a695d55b354e44d639a823b1c3f681"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/1a02a961a2d53f21bf208f07903a97cc46f43e17/databases/mysql80-server/files/patch-sql_mdl__context__backup.cc"
    sha256 "501646e1cb6ac2ddc5eb42755d340443e4655741d6e76788f48751a2fb8f3775"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/1a02a961a2d53f21bf208f07903a97cc46f43e17/databases/mysql80-server/files/patch-sql_mdl__context__backup.h"
    sha256 "e515b565d1501648ce3de0add12b67c63aecb3ec4db3794de72c4eeb301ff343"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/1a02a961a2d53f21bf208f07903a97cc46f43e17/databases/mysql80-server/files/patch-sql_range__optimizer_index__range__scan__plan.cc"
    sha256 "44b5e76373fadd97560d66dae0dac14d98ae9a5c32d58d876bfe694016872bc7"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/1a02a961a2d53f21bf208f07903a97cc46f43e17/databases/mysql80-server/files/patch-sql_rpl__log__encryption.cc"
    sha256 "bdadcf4317295d1847283e20dd7fbfa2df2c4acebf45d5a13d0670bc7311f7ba"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/1a02a961a2d53f21bf208f07903a97cc46f43e17/databases/mysql80-server/files/patch-sql_stream__cipher.cc"
    sha256 "ac74c60f6051223993c88e7a11ddd9512c951ac1401d719a2c3377efe1bee3cf"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/1a02a961a2d53f21bf208f07903a97cc46f43e17/databases/mysql80-server/files/patch-sql_stream__cipher.h"
    sha256 "9a11d4658f60a63f3f10ff97a5170e865afde3ebee3e703d8272aba3cf6e32d0"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/1a02a961a2d53f21bf208f07903a97cc46f43e17/databases/mysql80-server/files/patch-unittest_gunit_binlogevents_transaction__compression-t.cc"
    sha256 "3bd0c22a2ee30a7b1e682e645dbdf473d4f0d6f8e5ffc447f088c5f1bf21efd7"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/freebsd/freebsd-ports/1a02a961a2d53f21bf208f07903a97cc46f43e17/databases/mysql80-server/files/patch-unittest_gunit_stream__cipher-t.cc"
    sha256 "9e7629a2174e754487737ef0d73c79fc1ed47ba54a982a3a4803e19c72c5dc0f"
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
    keep = %w[duktape libkmip lz4 rapidjson robin-hood-hashing]
    (buildpath/"extra").each_child { |dir| rm_r(dir) unless keep.include?(dir.basename.to_s) }
    (buildpath/"boost").install resource("boost")

    perl = "/usr/bin/perl"
    if OS.linux?
      perl = Formula["perl"].opt_bin/"perl"
      # Disable ABI checking
      inreplace "cmake/abi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0"
    end

    # Make sure Perl from `perl-dbd-mysql` is used at runtime. Otherwise may have incompatible modules
    inreplace "storage/innobase/xtrabackup/src/backup_copy.cc", 'popen("perl",', "popen(\"#{perl}\","

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
      -DWITH_BOOST=#{buildpath}/boost
      -DWITH_EDITLINE=system
      -DWITH_LIBEVENT=system
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
    bin.env_script_all_files(libexec/"bin", PERL5LIB: Formula["perl-dbd-mysql"].opt_libexec/"lib/perl5")

    # remove conflicting library that is already installed by mysql
    (lib/"libmysqlservices.a").unlink
    # remove conflicting libraries/headers that are installed by percona-server
    (lib/"libkmip.a").unlink
    (lib/"libkmippp.a").unlink
    (include/"kmip.h").unlink
    (include/"kmippp.h").unlink
  end

  test do
    mysql = Formula["mysql@8.0"]
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
      assert_match "version_check Done.", output # check Perl modules work
      assert_path_exists testpath/"backup/xtrabackup_info"
    ensure
      system mysql.bin/"mysqladmin", *mysqladmin_args, "shutdown"
      Process.kill "TERM", pid
    end
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 42e63d0..5d21cc3 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -1942,31 +1942,6 @@ MYSQL_CHECK_RAPIDJSON()
 MYSQL_CHECK_FIDO()
 MYSQL_CHECK_FIDO_DLLS()

-IF(APPLE)
-  GET_FILENAME_COMPONENT(HOMEBREW_BASE ${HOMEBREW_HOME} DIRECTORY)
-  IF(EXISTS ${HOMEBREW_BASE}/include/boost)
-    FOREACH(SYSTEM_LIB ICU LIBEVENT LZ4 PROTOBUF ZSTD FIDO)
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
-  FOREACH(SYSTEM_LIB ICU LIBEVENT LZ4 PROTOBUF ZSTD FIDO)
-    IF(WITH_${SYSTEM_LIB} STREQUAL "system")
-      INCLUDE_DIRECTORIES(SYSTEM ${HOMEBREW_BASE}/include)
-      BREAK()
-    ENDIF()
-  ENDFOREACH()
-ENDIF()
-
 IF(WITH_AUTHENTICATION_FIDO OR WITH_AUTHENTICATION_CLIENT_PLUGINS)
   IF(WITH_FIDO STREQUAL "system" AND
     NOT WITH_SSL STREQUAL "system")
diff --git i/sql/rpl_log_encryption.cc w/sql/rpl_log_encryption.cc
index eea6a031..49352260 100644
--- i/sql/rpl_log_encryption.cc
+++ w/sql/rpl_log_encryption.cc
@@ -449,7 +449,7 @@ bool Rpl_encryption::enable_for_xtrabackup() {
         Rpl_encryption_header::seqno_to_key_id(m_master_key_seqno);
     auto master_key =
         get_key(m_master_key.m_id, Rpl_encryption_header::get_key_type());
-    m_master_key.m_value.assign(master_key.second);
+    m_master_key.m_value = master_key.second ;
     /* No keyring error */
     if (master_key.first == Keyring_status::KEYRING_ERROR_FETCHING) res = true;
   }
diff --git i/storage/innobase/xtrabackup/src/keyring_plugins.cc w/storage/innobase/xtrabackup/src/keyring_plugins.cc
index 00ab43e2..7992ab0e 100644
--- i/storage/innobase/xtrabackup/src/keyring_plugins.cc
+++ w/storage/innobase/xtrabackup/src/keyring_plugins.cc
@@ -890,7 +890,7 @@ bool xb_binlog_password_reencrypt(const char *binlog_file_path) {
     return (false);
   }
 
-  Key_string file_password(key, Encryption::KEY_LEN);
+  Key_string file_password(key, key + Encryption::KEY_LEN);
   header->encrypt_file_password(file_password);
 
   IO_CACHE_ostream ostream;
