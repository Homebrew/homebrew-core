class MariadbConnectorOdbc < Formula
  desc "MariaDB Standardized database driver"
  homepage "https://downloads.mariadb.org/connector-odbc/"
  url "https://github.com/MariaDB/mariadb-connector-odbc/archive/2.0.13.tar.gz"
  sha256 "6b77e879335ea32dad40d42de95930df8ad557faa887b414a09ab7ead3ce963c"

  depends_on "cmake" => :build
  depends_on "mariadb-connector-c"
  depends_on "unixodbc"
  depends_on "openssl"

  patch :DATA

  def install
    system "cmake", ".", "-DWITH_UNIXODBC=1", "-DMARIADB_FOUND=1", "-DWITH_OPENSSL=1", "-DOPENSSL_INCLUDE_DIR=/usr/local/opt/openssl/include/", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{Formula["unixodbc"].bin}/dltest #{lib}/libmaodbc.dylib")
    assert_equal "SUCCESS: Loaded #{lib}/libmaodbc.dylib\n", output
  end
end

__END__
diff --git a/cmake/FindIconv.cmake b/cmake/FindIconv.cmake
index f0768f7..a3f3eaa 100644
--- a/cmake/FindIconv.cmake
+++ b/cmake/FindIconv.cmake
@@ -9,6 +9,7 @@ IF(APPLE)
   find_path(ICONV_INCLUDE_DIR iconv.h PATHS
             /opt/local/include/
             /usr/include/
+            /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/
             NO_CMAKE_SYSTEM_PATH)
 ELSE()
   find_path(ICONV_INCLUDE_DIR iconv.h)
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 4104ad0..a9bbf32 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -127,6 +127,15 @@ IF(NOT WIN32)
   ELSE()
     MESSAGE(FATAL_ERROR "Driver Manager was not found")
   ENDIF()
+
+  # Looking for iconv files
+  INCLUDE(${CMAKE_SOURCE_DIR}/cmake/FindIconv.cmake)
+  IF(ICONV_FOUND)
+    INCLUDE_DIRECTORIES(${ICONV_INCLUDE_DIR})
+    SET(PLATFORM_DEPENDENCIES ${PLATFORM_DEPENDENCIES} ${ICONV_LIBRARIES})
+  ELSE()
+    MESSAGE(FATAL_ERROR "iconv was not found")
+  ENDIF()
 ENDIF()

 SET(CPACK_PACKAGE_VERSION ${MARIADB_ODBC_VERSION_MAJOR}.${MARIADB_ODBC_VERSION_MINOR}.${MARIADB_ODBC_VERSION_PATCH})
