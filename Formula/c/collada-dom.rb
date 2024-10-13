class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM"
  url "https://github.com/rdiankov/collada-dom/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "3be672407a7aef60b64ce4b39704b32816b0b28f61ebffd4fbd02c8012901e0d"
  license "MIT"
  revision 10
  head "https://github.com/rdiankov/collada-dom.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "93ee168d5e413ac9709071615535b1e41a69104a256874a88c455b93a69473cd"
    sha256 cellar: :any,                 arm64_sonoma:   "a23c3731eff60bcd2dc079fa88da110bdfa807137fe18cdd7893677cd522fd3c"
    sha256 cellar: :any,                 arm64_ventura:  "5f851bdfae69110c8648205d9f44267c722bbd424a2727649a0442c82c625e30"
    sha256 cellar: :any,                 arm64_monterey: "46407af6b516e2a49f330278953d8d2fa6d0de217cfde68cfe53990f1dc5e33a"
    sha256 cellar: :any,                 sonoma:         "4483eedf90d10b9c7306280fafc002e5c1f7c85f2925e1b13466c7c87c3683fb"
    sha256 cellar: :any,                 ventura:        "90845ce55f8153dd85582570f9955e91b39a56c14a7543ac5412dee3577797cf"
    sha256 cellar: :any,                 monterey:       "59f34d806302668ae9cbde4ac0cdec8f024f16b4d75b84ceadf04edf1334682f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95b9bf434a46b41bf05bc4a847f8c560ef500e7ba4b6891ea2d49a8c6d271918"
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
    rm_r(buildpath/"dom/external-libs")

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
