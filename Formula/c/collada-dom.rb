class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM"
  url "https://github.com/rdiankov/collada-dom/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "3be672407a7aef60b64ce4b39704b32816b0b28f61ebffd4fbd02c8012901e0d"
  license "MIT"
  revision 9
  head "https://github.com/rdiankov/collada-dom.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b96ee02cb3ba9976f95da7a9ad8480ae236075e2120f12da228d40bbb0468fc"
    sha256 cellar: :any,                 arm64_ventura:  "1f9c4e85aff69a46deb4c726ce8bee8989b973c372fbdcb66706c7a1f9c07277"
    sha256 cellar: :any,                 arm64_monterey: "121ba525d1bb601e360f898692cec0af348756d5edec73df0d701a42ba993350"
    sha256 cellar: :any,                 sonoma:         "f9e6ed22404314db701d551d9b4d6507b1755689b3b8d930a38b890f4f4552fa"
    sha256 cellar: :any,                 ventura:        "f1d8fa9ecaab9ec6cf16ab93e4941963c868d0b6a2cbffebd5717f1fbbd5bba8"
    sha256 cellar: :any,                 monterey:       "75db596eb27853c04f15d4df1bfb5b6dd7b6205e05796f923cba10cec59282d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a032874ec251f8e8d8efb7a52fca15616e5fe4d66c4eae78b38f3633e2339a3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "minizip"
  depends_on "uriparser"

  uses_from_macos "libxml2"

  # Fix build failure with `boost` 1.85.0.
  # Issue ref: https://github.com/rdiankov/collada-dom/issues/42
  patch :DATA

  def install
    # Remove bundled libraries to avoid fallback
    (buildpath/"dom/external-libs").rmtree

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=11", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <dae.h>
      #include <dae/daeDom.h>

      using namespace std;

      int main()
      {
        cout << GetCOLLADA_VERSION() << endl;
        return 0;
      }
    EOS
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
