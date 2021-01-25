class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://github.com/maxbube/mydumper/archive/v0.10.1.tar.gz"
  sha256 "66b64f0c9410143ab4a32794f58769965495ac0385882b239f2c928281c1e798"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "7d69132e5dc16095b3505e9e0d9a32d007ed59aaddc434080aca281be67b89f0" => :big_sur
    sha256 "2a6e0ac0dc3666bd2b4968a3e860781b06972794124579cffa4d01f8f7aac0e5" => :arm64_big_sur
    sha256 "c4209a1c5683a68bbbf7ef285bd3426ccc356c0c4d3b605ebe239883b060e743" => :catalina
    sha256 "474f771d2bc3621402c21ffe07286f7a67b5e344209514ef63d55c1f2bf8b266" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "zlib"

  # This patch allows cmake to find .dylib shared libs in macOS. A bug report has
  # been filed upstream here: https://bugs.launchpad.net/mydumper/+bug/1517966
  # It also ignores .a libs because of an issue with glib's static libraries now
  # being included by default in homebrew.
  #
  # Although we override the mysql library location this patch is still required
  # because the setting of ${CMAKE_FIND_LIBRARY_SUFFIXES} affects other probes as well.
  patch :p0, :DATA

  def install
    system "cmake", ".", *std_cmake_args,
           # Override location of mysql-client:
           "-DMYSQL_CONFIG_PREFER_PATH=#{Formula["mysql-client"].opt_bin}",
           "-DMYSQL_LIBRARIES=#{Formula["mysql-client"].opt_lib}/libmysqlclient.dylib",
           # find_package(ZLIB) has troube on Big Sur since physical libz.dylib
           # doesn't exist on the filesystem.  Instead provide details ourselves:
           "-DCMAKE_DISABLE_FIND_PACKAGE_ZLIB=1", "-DZLIB_INCLUDE_DIRS=/usr/include", "-DZLIB_LIBRARIES=-lz"
    system "make", "install"
  end

  test do
    system bin/"mydumper", "--help"
  end
end

__END__
--- cmake/modules/FindMySQL.cmake	2015-09-16 16:11:34.000000000 -0400
+++ cmake/modules/FindMySQL.cmake	2015-09-16 16:10:56.000000000 -0400
@@ -84,7 +84,7 @@
 )

 set(TMP_MYSQL_LIBRARIES "")
-set(CMAKE_FIND_LIBRARY_SUFFIXES .so .a .lib .so.1)
+set(CMAKE_FIND_LIBRARY_SUFFIXES .so .lib .dylib .so.1)
 foreach(MY_LIB ${MYSQL_ADD_LIBRARIES})
     find_library("MYSQL_LIBRARIES_${MY_LIB}" NAMES ${MY_LIB}
         HINTS
