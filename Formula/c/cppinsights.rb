class Cppinsights < Formula
  desc "See your source code with the eyes of a compiler"
  homepage "https://cppinsights.io/"
  url "https://github.com/andreasfertig/cppinsights/archive/refs/tags/v_17.0.tar.gz"
  sha256 "2dd6bcfcdba65c0ed2e1f04ef79d57285186871ad8bd481d63269f3115276216"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "96323129186a6544a116c838c12b1f3553afed284acc34f9dab10be492c67931"
    sha256 cellar: :any,                 arm64_ventura:  "2d0955d7f8b5d8755a3e2ac7877561eb447e3cf94ac6675c88c91324047c9ebf"
    sha256 cellar: :any,                 arm64_monterey: "977d8ed27ed1b3fe8435290de94c923c1f8b1466f31899e78debff7b6d610f90"
    sha256 cellar: :any,                 sonoma:         "086658af37dfd1cd02e2964c87ac811aec7878cb248b8184d07cbb52623ae29e"
    sha256 cellar: :any,                 ventura:        "144b6339feb3dda9c22489ca2f4c491cb9f104a19a5d8c7cdea07c0e190cb6aa"
    sha256 cellar: :any,                 monterey:       "0bb503eeef577a4824d930902468acde8b401485c7abe24254734497caf0c6f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a83984ed67773a0e00370010c90b7d841f32cd7791ff3a53ebf160607177799b"
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
