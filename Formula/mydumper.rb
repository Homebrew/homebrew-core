class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://launchpad.net/mydumper/0.9/0.9.1/+download/mydumper-0.9.1.tar.gz"
  sha256 "aefab5dc4192acb043d685b6bb952c87557fbea5e083b8547c68ccfec878171f"
  revision 3

  bottle do
    cellar :any
    sha256 "1ad797094a34d26b1318e6c163e1101bf6476344e2a1323cb49b92245b24fc23" => :catalina
    sha256 "513f5969ca02f512bc7733928ed903781d6c6e9ece655b0d287de9d23f3a8b3d" => :mojave
    sha256 "0066ef9e9a957e31fe089f11b2afc2626d3cc4b2ec0b05ba2179467401850624" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mysql-client"
  depends_on "openssl@1.1"
  depends_on "pcre"

  # This patch allows cmake to find .dylib shared libs in macOS. A bug report has
  # been filed upstream here: https://bugs.launchpad.net/mydumper/+bug/1517966
  # It also ignores .a libs because of an issue with glib's static libraries now
  # being included by default in homebrew.
  patch :p0, :DATA

  def install
    system "cmake", ".", *std_cmake_args
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
-set(CMAKE_FIND_LIBRARY_SUFFIXES .so .a .lib)
+set(CMAKE_FIND_LIBRARY_SUFFIXES .so .lib .dylib)
 foreach(MY_LIB ${MYSQL_ADD_LIBRARIES})
     find_library("MYSQL_LIBRARIES_${MY_LIB}" NAMES ${MY_LIB}
         HINTS
