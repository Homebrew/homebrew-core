class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM"
  url "https://github.com/rdiankov/collada-dom/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "3be672407a7aef60b64ce4b39704b32816b0b28f61ebffd4fbd02c8012901e0d"
  license "MIT"
  revision 16
  head "https://github.com/rdiankov/collada-dom.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4b56321a5c325382cbf770e59dd9fd2df00cd00820e64ae6ad990a88c26032eb"
    sha256 cellar: :any, arm64_sequoia: "4dbea299cf21aee0664c40c530f2cd06d0d431c77ee88259a2b98a9331e92092"
    sha256 cellar: :any, arm64_sonoma:  "b5602536f16d3fdd2b12a4ff6b367742849f361a1605323d8ce87ef9c111bd14"
    sha256 cellar: :any, sonoma:        "d48c4fa578ae2ee7659af5b15353a0c8001bddc33b1c6d127f9795da90f2a758"
    sha256 cellar: :any, arm64_linux:   "19d7e6378edde3b5c2611daae1a7730e6efae6a1e1fe431f0c4304bb544a0055"
    sha256 cellar: :any, x86_64_linux:  "653bd1885aea94fa9b609402554a8cf63a1020954e116413acc6cc239b1f0e79"
  end

  deprecate! date: "2026-05-04", because: :unmaintained
  disable! date: "2027-05-04", because: :unmaintained

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "minizip"
  depends_on "uriparser"

  uses_from_macos "libxml2"

  # Fix build failure with `boost` 1.85.0 and 1.89.0.
  # Issue ref: https://github.com/rdiankov/collada-dom/issues/42
  patch :DATA

  def install
    # Remove bundled libraries to avoid fallback
    rm_r(buildpath/"dom/external-libs")

    # Minizip header is in a `minizip` subdirectory, but upstream didn't account for that.
    inreplace "CMakeLists.txt", "set(MINIZIP_INCLUDE_DIR ${minizip_INCLUDE_DIRS}", "\\0/minizip"

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=11",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <dae.h>
      #include <dae/daeDom.h>

      using namespace std;

      int main()
      {
        cout << GetCOLLADA_VERSION() << endl;
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}/collada-dom2.5",
                    "-L#{lib}", "-lcollada-dom2.5-dp", "-o", "test"

    # This is the DAE file version, not the package version
    assert_equal "1.5.0", shell_output("./test").chomp
  end
end

__END__
diff --git a/dom/include/dae.h b/dom/include/dae.h
index e53388b..a14276a 100644
--- a/dom/include/dae.h
+++ b/dom/include/dae.h
@@ -25,7 +25,7 @@
 #pragma warning(disable: 4180 4245)
 #endif
 #ifndef NO_BOOST
-#include <boost/filesystem/convenience.hpp>
+#include <boost/filesystem/operations.hpp>
 #endif
 #ifdef _MSC_VER
 #pragma warning(pop)
diff --git a/dom/src/dae/daeUtils.cpp b/dom/src/dae/daeUtils.cpp
index de30ca0..011a852 100644
--- a/dom/src/dae/daeUtils.cpp
+++ b/dom/src/dae/daeUtils.cpp
@@ -18,7 +18,7 @@
 #endif

 #ifndef NO_BOOST
-#include <boost/filesystem/convenience.hpp>       // THIS WAS NOT COMMENTED.
+#include <boost/filesystem/operations.hpp>       // THIS WAS NOT COMMENTED.
 #endif

 #include <cstdio> // for tmpnam
diff --git a/dom/src/dae/daeZAEUncompressHandler.cpp b/dom/src/dae/daeZAEUncompressHandler.cpp
index da2a344..2550000 100644
--- a/dom/src/dae/daeZAEUncompressHandler.cpp
+++ b/dom/src/dae/daeZAEUncompressHandler.cpp
@@ -271,7 +271,7 @@ bool daeZAEUncompressHandler::checkAndExtractInternalArchive( const std::string&
     bool error = false;

     boost::filesystem::path archivePath(filePath);
-    std::string dir = archivePath.branch_path().string();
+    std::string dir = archivePath.parent_path().string();

     const std::string& randomSegment = cdom::getRandomFileName();
     std::string tmpDir = dir + cdom::getFileSeparator() + randomSegment + cdom::getFileSeparator();
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 20635b2..adcc250 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -159,7 +159,7 @@ endif()
 if( NOT $ENV{BOOST_LIBRARYDIR} STREQUAL "" )
   set(Boost_LIBRARY_DIRS $ENV{BOOST_LIBRARYDIR})
 endif()
-find_package(Boost COMPONENTS filesystem system REQUIRED)
+find_package(Boost COMPONENTS filesystem REQUIRED)
 
 message(STATUS "found boost version: ${Boost_VERSION}")
 
