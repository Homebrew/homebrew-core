class MysqlClient < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/8.0/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.33.tar.gz"
  sha256 "ae31e6368617776b43c82436c3736900067fada1289032f3ac3392f7380bcb58"
  license "GPL-2.0-only" => { with: "Universal-FOSS-exception-1.0" }
  revision 1

  livecheck do
    formula "mysql"
  end

  bottle do
    sha256 arm64_ventura:  "739aa338fbc7a8d004fc9cdf4ea6712df345ad626fe42b72eaf5e01b29e0f006"
    sha256 arm64_monterey: "cb7626e6e691ca3187ab3f2af7e28ef026b8c238a751dfcae0a1841434abb2b5"
    sha256 arm64_big_sur:  "c0ba3142b8b12c06e83ea7ad4b1b2dfe80e25e762cc09c5cdb0861b58acce9f1"
    sha256 ventura:        "02903af4450a4f15849a5bda4527116dceeea140dc07e1657f491cf4fb3360c4"
    sha256 monterey:       "f6a2ead14b54c2e1e6698e234a0e6fe4fb4a0708b1a61960dd7d0e18757b354b"
    sha256 big_sur:        "276c813d9fa84651857e8bfd8e0da52d90685fc4176dfb86129603c325d5d723"
    sha256 x86_64_linux:   "0f2127165a0da522a771a6d52cee9b91204cc8db12c01c18eca03eddc73e6bae"
  end

  keg_only "it conflicts with mysql (which contains client libraries)"

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
