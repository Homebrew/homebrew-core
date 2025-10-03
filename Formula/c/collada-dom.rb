class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM"
  url "https://github.com/rdiankov/collada-dom/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "3be672407a7aef60b64ce4b39704b32816b0b28f61ebffd4fbd02c8012901e0d"
  license "MIT"
  revision 13
  head "https://github.com/rdiankov/collada-dom.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "79f4fe2716ff40c5d428aa426e196a4e7f4d35650ba98aa8e94ff6b7240872d1"
    sha256 cellar: :any,                 arm64_sequoia: "121ac6caf851ce8419fdcd32022e39581347816399d24dcb831c042d0a4e1ff9"
    sha256 cellar: :any,                 arm64_sonoma:  "4369bf4e5c16cf901edbbdaec4b1e374fa42dee2a527c6cfc6c55bdc5e7dd4c2"
    sha256 cellar: :any,                 arm64_ventura: "c3386425b2597b815b79002e2bfa629e4c8c92b50119def90c2e63153f86eacb"
    sha256 cellar: :any,                 sonoma:        "d649bd1ff5c6c3db62909c949f9ce6f6713b46fed91255ef93be32742ca58b7b"
    sha256 cellar: :any,                 ventura:       "3c00de7fa89c1d6e750d77308ccc56f46e0698e4192e42c33d420e0534ab9535"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62ec1ee257626dd9e7f5c1c874695a99a388401a0597d8f4bf9c9fc22caef0a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "405679197a0c02d886159df43321ac8d3553bb91089aa61da54a83c3643ee18f"
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
 
