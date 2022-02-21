class PerconaXtrabackup < Formula
  desc "Open source hot backup tool for InnoDB and XtraDB databases"
  homepage "https://www.percona.com/software/mysql-database/percona-xtrabackup"
  url "https://downloads.percona.com/downloads/Percona-XtraBackup-LATEST/Percona-XtraBackup-8.0.27-19/source/tarball/percona-xtrabackup-8.0.27-19.tar.gz"
  sha256 "0bcfc60b2b19723ea348e43b04bd904c49142f58d326ab32db11e69dda00b733"

  livecheck do
    url "https://www.percona.com/downloads/Percona-XtraBackup-LATEST/"
    regex(/value=.*?Percona-XtraBackup[._-]v?(\d+(?:\.\d+)+-\d+)["' >]/i)
  end

  bottle do
    sha256 arm64_monterey: "8fb924ae54f28708933b9afcd06423e45b40f9a33b0c6dd72d0156a430c3f43a"
    sha256 arm64_big_sur:  "45e372cb3dbc06e4598b9730a2d966b7b5acdbf26f1cdd1fec476c9343a76264"
    sha256 monterey:       "3fe3ef97609466a2213e6d301584bfa0071cf13b30fdfb3c6252283075f59bf9"
    sha256 big_sur:        "7678afb4036a12a8a57ecc72544ad01ee8daf1987da5e6b9fd15644e13e163e0"
    sha256 catalina:       "ac2777de2bced8fc020ef76f1275da999f11cb3c60481d97006f8cbac9403a97"
    sha256 mojave:         "880abb4be9f118120660818a079cdc4562cc7411a1a9070d3ef005c8aee23f35"
    sha256 x86_64_linux:   "bbe0e5b72dc9bd03415c999aaa45a8ed4d30294f56bad35200fbdbc8d1f552df"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build
  depends_on "icu4c"
  depends_on "libev"
  depends_on "libevent"
  depends_on "libgcrypt"
  depends_on "lz4"
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "zstd"

  uses_from_macos "vim" => :build # needed for xxd
  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "libedit"
  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "gcc" # Requires GCC 7.1 or later
    depends_on "libaio"
  end

  fails_with :gcc do
    version "6"
    cause "The build requires GCC 7.1 or later."
  end

  # Should be installed before DBD::mysql
  resource "Devel::CheckLib" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTN/Devel-CheckLib-1.14.tar.gz"
    sha256 "f21c5e299ad3ce0fdc0cb0f41378dca85a70e8d6c9a7599f0e56a957200ec294"
  end

  # This is not part of the system Perl on Linux and on macOS since Mojave
  resource "DBI" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TIMB/DBI-1.643.tar.gz"
    sha256 "8a2b993db560a2c373c174ee976a51027dd780ec766ae17620c20393d2e836fa"
  end

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/D/DV/DVEEDEN/DBD-mysql-4.050.tar.gz"
    sha256 "4f48541ff15a0a7405f76adc10f81627c33996fbf56c95c26c094444c0928d78"
  end

  # https://github.com/percona/percona-xtrabackup/blob/percona-xtrabackup-#{version}/cmake/boost.cmake
  resource "boost" do
    url "https://boostorg.jfrog.io/artifactory/main/release/1.73.0/source/boost_1_73_0.tar.bz2"
    sha256 "4eb3b8d442b426dc35346235c8733b5ae35ba431690e38c6a8263dce9fcbb402"
  end

  # Fix build on Monterey.
  # Remove with the next version.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/fcbea58e245ea562fbb749bfe6e1ab178fd10025/mysql/monterey.diff"
    sha256 "6709edb2393000bd89acf2d86ad0876bde3b84f46884d3cba7463cd346234f6f"
  end

  # Fix linkage errors on macOS.
  # Remove with the next version.
  patch do
    url "https://github.com/percona/percona-xtrabackup/commit/89004bb0a67b73daeafc6a5008d0eefc2e80134b.patch?full_index=1"
    sha256 "53f1f444e7d924b6a58844a3f9be521ccde70d2adeed7e6ba4f513ceedc82ec4"
  end

  # Fix build on macOS.
  patch :DATA

  def install
    # Disable ABI checking
    inreplace "cmake/abi_check.cmake", "RUN_ABI_CHECK 1", "RUN_ABI_CHECK 0" if OS.linux?

    cmake_args = %W[
      -DBUILD_CONFIG=xtrabackup_release
      -DCOMPILATION_COMMENT=Homebrew
      -DINSTALL_PLUGINDIR=lib/percona-xtrabackup/plugin
      -DINSTALL_MANDIR=share/man
      -DWITH_MAN_PAGES=ON
      -DINSTALL_MYSQLTESTDIR=
      -DWITH_SYSTEM_LIBS=ON
      -DWITH_EDITLINE=system
      -DWITH_ICU=system
      -DWITH_LIBEVENT=system
      -DWITH_LZ4=system
      -DWITH_PROTOBUF=system
      -DWITH_SSL=system
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
    ]

    # macOS has this value empty by default.
    # See https://bugs.python.org/issue18378#msg215215
    ENV["LC_ALL"] = "en_US.UTF-8"

    (buildpath/"boost").install resource("boost")
    cmake_args << "-DWITH_BOOST=#{buildpath}/boost"

    cmake_args.concat std_cmake_args

    # Remove conflicting manpages
    rm (Dir["man/*"] - ["man/CMakeLists.txt"])

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make"
      system "make", "install"
    end

    # remove conflicting library that is already installed by mysql
    rm lib/"libmysqlservices.a"

    if OS.mac?
      # Remove libssl copies as the binaries use the keg anyway and they create problems for other applications
      rm lib/"libssl.dylib"
      rm lib/"libssl.1.1.dylib"
      rm lib/"libcrypto.1.1.dylib"
      rm lib/"libcrypto.dylib"
    end

    ENV.prepend_create_path "PERL5LIB", buildpath/"build_deps/lib/perl5"

    resource("Devel::CheckLib").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}/build_deps"
      system "make", "install"
    end

    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    # This is not part of the system Perl on Linux and on macOS since Mojave
    if OS.linux? || MacOS.version >= :mojave
      resource("DBI").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    resource("DBD::mysql").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    bin.env_script_all_files(libexec/"bin", PERL5LIB: libexec/"lib/perl5")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xtrabackup --version 2>&1")

    mkdir "backup"
    output = shell_output("#{bin}/xtrabackup --target-dir=backup --backup 2>&1", 1)
    assert_match "Failed to connect to MySQL server", output
  end
end

__END__
diff --git a/man/CMakeLists.txt b/man/CMakeLists.txt
index 26894cd6..8ab7e3d7 100644
--- a/man/CMakeLists.txt
+++ b/man/CMakeLists.txt
@@ -25,55 +25,11 @@ FILE(GLOB MAN1 *.1)
 FILE(GLOB MAN1_NDB ndb*.1)
 FILE(GLOB MAN8 *.8)
 FILE(GLOB MAN8_NDB ndb*.8)
+
 IF(MAN1_NDB AND NOT WITH_NDBCLUSTER)
   LIST(REMOVE_ITEM MAN1 ${MAN1_NDB})
 ENDIF()
-
-SET(MAN1_NDB
-  ndb_blob_tool.1
-  ndb_config.1
-  ndb_cpcd.1
-  ndb_delete_all.1
-  ndb_desc.1
-  ndb_drop_index.1
-  ndb_drop_table.1
-  ndb_error_reporter.1
-  ndb_import.1
-  ndb_index_stat.1
-  ndb_mgm.1
-  ndb_move_data.1
-  ndb_perror.1
-  ndb_print_backup_file.1
-  ndb_print_file.1
-  ndb_print_frag_file.1
-  ndb_print_schema_file.1
-  ndb_print_sys_file.1
-  ndb_redo_log_reader.1
-  ndb_restore.1
-  ndb_select_all.1
-  ndb_select_count.1
-  ndb_show_tables.1
-  ndb_size.pl.1
-  ndb_top.1
-  ndb_waiter.1
-  ndbinfo_select_all.1
-)
-SET(MAN1_ROUTER
-  mysqlrouter.1
-  mysqlrouter_passwd.1
-  mysqlrouter_plugin_info.1
-)
-SET(MAN8
-  mysqld.8
-  )
-SET(MAN8_NDB
-  ndb_mgmd.8
-  ndbd.8
-  ndbmtd.8
-)
-
 INSTALL(FILES ${MAN1} DESTINATION ${INSTALL_MANDIR}/man1 COMPONENT ManPages)
-INSTALL(FILES ${MAN8} DESTINATION ${INSTALL_MANDIR}/man8 COMPONENT ManPages)
 
 IF(MAN8_NDB AND NOT WITH_NDBCLUSTER)
   LIST(REMOVE_ITEM MAN8 ${MAN8_NDB})
diff --git a/storage/innobase/xtrabackup/src/ds_local.cc b/storage/innobase/xtrabackup/src/ds_local.cc
index d7f9613e..a5ec8126 100644
--- a/storage/innobase/xtrabackup/src/ds_local.cc
+++ b/storage/innobase/xtrabackup/src/ds_local.cc
@@ -25,7 +25,11 @@ Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
 #include <mysql/service_mysql_alloc.h>
 #include <mysql_version.h>
 #include <mysys_err.h>
+
+#ifdef HAVE_FALLOC_PUNCH_HOLE_AND_KEEP_SIZE
 #include <linux/falloc.h>
+#endif
+
 #include "common.h"
 #include "datasink.h"
 
