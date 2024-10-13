class Cppinsights < Formula
  desc "See your source code with the eyes of a compiler"
  homepage "https://cppinsights.io/"
  url "https://github.com/andreasfertig/cppinsights/archive/refs/tags/v_17.0.tar.gz"
  sha256 "2dd6bcfcdba65c0ed2e1f04ef79d57285186871ad8bd481d63269f3115276216"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "75a73b5aa7725274922c8a7d140313cce6fd95e39374e2e677759568e407840a"
    sha256 cellar: :any,                 arm64_sonoma:  "1cab5ed788571093faf15dcda82c042b470bac850e2de62f69e99bf2c7e7330e"
    sha256 cellar: :any,                 arm64_ventura: "23f3600ff5108c1b9be5525c295f6696c1caebbf7705cf91edf30399402ff1d4"
    sha256 cellar: :any,                 sonoma:        "67c44fa535a4314786580932ee508bd33d62661355f623cac5ff8dd83a158bdd"
    sha256 cellar: :any,                 ventura:       "07d8c5dcd3af7a9da011a033e0b2d4fbdb19e537f41ab7e2a7a324a8a4f07788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e1fb6833d6e99d81766f6ff9540194c0c04267bd53ca6e077ed525be84e4487"
  end

  depends_on "cmake" => :build
  depends_on "llvm@18"
  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  fails_with :clang do
    build 1500
    cause "Requires Clang > 15.0"
  end

  # Patch from https://github.com/andreasfertig/cppinsights/pull/622
  # Support for LLVM 18, remove in next version
  patch :DATA

  def install
    if OS.mac? && DevelopmentTools.clang_build_version <= 1500
      ENV.llvm_clang
      ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    end

    llvm18 = Formula["llvm@18"]
    ENV.append "LDFLAGS", "-L#{llvm18.lib}"

    system "cmake", "-S", ".", "-B", "build",
                    "-DINSIGHTS_LLVM_CONFIG=#{llvm18.opt_bin}/llvm-config",
                    "-DINSIGHTS_USE_SYSTEM_INCLUDES=Off",
                    *std_cmake_args
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
