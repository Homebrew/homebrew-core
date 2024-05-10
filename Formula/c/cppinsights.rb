class Cppinsights < Formula
  desc "See your source code with the eyes of a compiler"
  homepage "https://cppinsights.io/"
  url "https://github.com/andreasfertig/cppinsights/archive/refs/tags/v_17.0.tar.gz"
  sha256 "2dd6bcfcdba65c0ed2e1f04ef79d57285186871ad8bd481d63269f3115276216"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a73346fbd9edb64521a44f884289097c82361f2a0a459705dad0e8981b2f74fa"
    sha256 cellar: :any,                 arm64_ventura:  "3a1594c14be75f743a274b8f3e4093b122260d4ec82c9d67596f1141ce83d455"
    sha256 cellar: :any,                 arm64_monterey: "a1ce431bab70c47c4ec36092a09239b4786c45d1971ea1a4b670c15f8761fb60"
    sha256 cellar: :any,                 sonoma:         "05ebd00bb3dd6a28675df46610cb8e3713aa4a77395d7bb9dcc6ee1a70dd96e8"
    sha256 cellar: :any,                 ventura:        "847ad399da7cd8e1041a27a49ae0045257683e898116afff9f802cde794d8cd9"
    sha256 cellar: :any,                 monterey:       "a8abb0ff037bb8cefd1b94d7aff08f0afbc4923eb740c7bdb9cc69acc17c99c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04c0af7c3a2ca0b57f47099782d2bd08ab2148ef13e84f978c4a571cc8e695e1"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with :clang do
    build 1300
    cause "Requires C++20"
  end

  # Patch from https://github.com/andreasfertig/cppinsights/pull/622
  # Support for LLVM 18, remove in next version
  patch :DATA

  def install
    ENV.llvm_clang if ENV.compiler == :clang && DevelopmentTools.clang_build_version <= 1500

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      int main() {
        int arr[5]{2,3,4};
      }
    EOS
    assert_match "{2, 3, 4, 0, 0}", shell_output("#{bin}/insights ./test.cpp")
  end
end
__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 31341709..8b7430db 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -1,5 +1,4 @@
-cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
-# 3.8* is required because of C++17 support
+cmake_minimum_required(VERSION 3.20 FATAL_ERROR)
 
 # For better control enable MSVC_RUNTIME_LIBRARY target property
 # see https://cmake.org/cmake/help/latest/policy/CMP0091.html
@@ -33,7 +32,7 @@ option(INSIGHTS_STATIC              "Use static linking"         Off)
 
 set(INSIGHTS_LLVM_CONFIG "llvm-config" CACHE STRING "LLVM config executable to use")
 
-set(INSIGHTS_MIN_LLVM_MAJOR_VERSION 17)
+set(INSIGHTS_MIN_LLVM_MAJOR_VERSION 18)
 set(INSIGHTS_MIN_LLVM_VERSION ${INSIGHTS_MIN_LLVM_MAJOR_VERSION}.0)
 
 if(NOT DEFINED LLVM_VERSION_MAJOR)  # used when build inside the clang tool/extra folder
@@ -372,6 +371,17 @@ if (BUILD_INSIGHTS_OUTSIDE_LLVM)
     # additional libs required when building insights outside llvm
     set(ADDITIONAL_LIBS
         ${LLVM_LDFLAGS}
+    )
+
+    if(${LLVM_PACKAGE_VERSION_PLAIN} VERSION_GREATER_EQUAL "18.0.0")
+        set(ADDITIONAL_LIBS
+            ${ADDITIONAL_LIBS}
+            clangAPINotes
+        )
+    endif()
+
+    set(ADDITIONAL_LIBS
+        ${ADDITIONAL_LIBS}
         clangFrontend
         clangDriver
         clangSerialization
@@ -768,6 +778,7 @@ message(STATUS "[ Build summary ]")
 message(STATUS "CMAKE_GENERATOR       : ${CMAKE_GENERATOR}")
 message(STATUS "CMAKE_EXE_LINKER_FLAGS: ${CMAKE_EXE_LINKER_FLAGS}")
 message(STATUS "CMAKE_LINKER          : ${CMAKE_LINKER}")
+message(STATUS "CMAKE_OSX_ARCHITECTURES : ${CMAKE_OSX_ARCHITECTURES}")
 message(STATUS "Compiler ID           : ${CMAKE_CXX_COMPILER_ID}")
 message(STATUS "Compiler version      : ${CMAKE_CXX_COMPILER_VERSION}")
 message(STATUS "Compiler path         : ${CMAKE_CXX_COMPILER}")
