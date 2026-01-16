class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM"
  url "https://github.com/rdiankov/collada-dom/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "3be672407a7aef60b64ce4b39704b32816b0b28f61ebffd4fbd02c8012901e0d"
  license "MIT"
  revision 15
  head "https://github.com/rdiankov/collada-dom.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "571dd57bc1c55e2136dcca7348eb4ff31aee95a3d20178ea87a36061fe655a6a"
    sha256 cellar: :any,                 arm64_sequoia: "506e14ad369e4dbb9014a15b29f50ffe2b1d453877939de55a8112b3cb279d0d"
    sha256 cellar: :any,                 arm64_sonoma:  "591b6312ae7ade63b30c32eb21741b05e04f4cc8092a2c19e4c83f0946cfcf03"
    sha256 cellar: :any,                 sonoma:        "acac703a5648f3a6211283aeb24e3bdf2185671ecee70d2b00e139efce2925c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63dfeb474fccc391c52805334719c4dee901a1e9ed27194176a5d134315ab780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1e7a11c3863a2ed8f2b6a266299ddba1f536ae1dd3b7d97c75c2fd2de5a8084"
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
 
