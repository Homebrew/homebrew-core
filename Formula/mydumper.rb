class Mydumper < Formula
  desc "How MySQL DBA & support engineer would imagine 'mysqldump' ;-)"
  homepage "https://launchpad.net/mydumper"
  url "https://launchpad.net/mydumper/0.9/0.9.1/+download/mydumper-0.9.1.tar.gz"
  sha256 "aefab5dc4192acb043d685b6bb952c87557fbea5e083b8547c68ccfec878171f"
  revision 1

  bottle do
    cellar :any
    sha256 "08798a5d4fa3af367907a32963a55c166b5aaa654cd5708edb61ba907ee883e2" => :mojave
    sha256 "1b05e59ddf8d604e827cb19132162d4d8ebf98459f58ca57af9c5b9a089694f0" => :high_sierra
    sha256 "a4ed9559c67a607cef27874d667d6d4c5ee80d9663a45d6cc623cf457ea2284e" => :sierra
    sha256 "f470b334ba765d77a9df8193f2333f43fa617d0a1a95b38d1325ddb4b5c5f47c" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mysql-client"
  depends_on "openssl"
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
