class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM"
  url "https://github.com/rdiankov/collada-dom/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "3be672407a7aef60b64ce4b39704b32816b0b28f61ebffd4fbd02c8012901e0d"
  license "MIT"
  revision 14
  head "https://github.com/rdiankov/collada-dom.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "262ff6d093cd5cf4c93d6771dc5652189d1d0545c1ed5fb9ed7a0924d2394e6c"
    sha256 cellar: :any,                 arm64_sequoia: "13413012e59dd5274b56bcbedff590d2940e6f2929fe75e210d59e1ce79b1e4d"
    sha256 cellar: :any,                 arm64_sonoma:  "2e667eedc409a0c7d7fc905667fee3e9b99d3784993096cf9f8295b9a5a31c8b"
    sha256 cellar: :any,                 sonoma:        "1594a0565e3052099419571b88bd2cbceb229163ac33bf6d2a2c6025c3eab57d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a41950947d7ce752b2d9fb00fc3a0d035a57efdca87ce2ca471e2092797fdc9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "199d63bc915ff1606d3a61710ed010a564f6ed5235be4e2928651d9b610c1ac9"
  end

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
 
