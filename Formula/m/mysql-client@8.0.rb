class MysqlClientAT80 < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.34.tar.gz"
  sha256 "0b881a19bcef732cd4dbbfc8dfeb84eff61f5dfe0d9788d015d699733e0adf1f"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }

  livecheck do
    formula "mysql@8.0"
  end

  bottle do
    sha256 arm64_sonoma:   "05e847cab488ff1ee6efce3d2c2b4cd23de96a019267e474324b7714a0c33439"
    sha256 arm64_ventura:  "87ab7064db0bac620bb7fba66062e594c71ce86a87f29729f4b452169501104c"
    sha256 arm64_monterey: "248eb2aa4f84e2b9c4cbf1f2775d538fcf7171494d6f3b8ad2632d428d5f7714"
    sha256 arm64_big_sur:  "24028a62c41a83bdb66e80a6147d7d8af2dbb42c9846f0249b4ce2808738b862"
    sha256 sonoma:         "3259cb6b10ac7eedf5ac15d1e0586ce5613cc89b668b2a50766a8a711bd23412"
    sha256 ventura:        "6c1c5391dc81e2ad3f6000e21f82c273434801cc560a53c4f1d9e7188df11618"
    sha256 monterey:       "21f0930daa861c9a6e14c67092618a2b3aae5ee974e986dc71cb90738a1bd09d"
    sha256 big_sur:        "cbab29dc7390154cbd61c1c5653cad983dc69640484cbaf4163c867c0ea2d969"
    sha256 x86_64_linux:   "ccf8919d07249e0cf0279282590b22a4c3fc1c8affe81e6b19f2852f2ffbd80b"
  end

  keg_only :versioned_formula

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "libfido2"
  # GCC is not supported either, so exclude for El Capitan.
  depends_on macos: :sierra if DevelopmentTools.clang_build_version < 900
  depends_on "openssl@3"
  depends_on "zlib" # Zlib 1.2.12+
  depends_on "zstd"

  uses_from_macos "libedit"

  fails_with gcc: "5"

  # Fix for "Cannot find system zlib libraries" even though they are installed.
  # https://bugs.mysql.com/bug.php?id=110745
  patch :DATA

  def install
    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DFORCE_INSOURCE_BUILD=1
      -DCOMPILATION_COMMENT=Homebrew
      -DDEFAULT_CHARSET=utf8mb4
      -DDEFAULT_COLLATION=utf8mb4_general_ci
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MANDIR=share/man
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DWITH_BOOST=boost
      -DWITH_EDITLINE=system
      -DWITH_FIDO=system
      -DWITH_LIBEVENT=system
      -DWITH_ZLIB=system
      -DWITH_ZSTD=system
      -DWITH_SSL=yes
      -DWITH_UNIT_TESTS=OFF
      -DWITHOUT_SERVER=ON
    ]

    system "cmake", ".", *std_cmake_args, *args
    system "make", "install"

    # Fix bad linker flags in `mysql_config`.
    # https://bugs.mysql.com/bug.php?id=111011
    inreplace bin/"mysql_config", "-lzlib", "-lz"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql --version")
  end
end

__END__
diff --git a/cmake/zlib.cmake b/cmake/zlib.cmake
index 460d87a..36fbd60 100644
--- a/cmake/zlib.cmake
+++ b/cmake/zlib.cmake
@@ -50,7 +50,7 @@ FUNCTION(FIND_ZLIB_VERSION ZLIB_INCLUDE_DIR)
   MESSAGE(STATUS "ZLIB_INCLUDE_DIR ${ZLIB_INCLUDE_DIR}")
 ENDFUNCTION(FIND_ZLIB_VERSION)

-FUNCTION(FIND_SYSTEM_ZLIB)
+MACRO(FIND_SYSTEM_ZLIB)
   FIND_PACKAGE(ZLIB)
   IF(ZLIB_FOUND)
     ADD_LIBRARY(zlib_interface INTERFACE)
@@ -61,7 +61,7 @@ FUNCTION(FIND_SYSTEM_ZLIB)
         ${ZLIB_INCLUDE_DIR})
     ENDIF()
   ENDIF()
-ENDFUNCTION(FIND_SYSTEM_ZLIB)
+ENDMACRO(FIND_SYSTEM_ZLIB)

 MACRO (RESET_ZLIB_VARIABLES)
   # Reset whatever FIND_PACKAGE may have left behind.
