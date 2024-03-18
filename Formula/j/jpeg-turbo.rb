class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/3.0.2/libjpeg-turbo-3.0.2.tar.gz"
  sha256 "c2ce515a78d91b09023773ef2770d6b0df77d674e144de80d63e0389b3a15ca6"
  license "IJG"
  head "https://github.com/libjpeg-turbo/libjpeg-turbo.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "89b1342d1dd69be94c1e293c8fc0ec5d324cd62f42bc8c3e9049bf5452957e01"
    sha256 cellar: :any,                 arm64_ventura:  "0673df94b246dd4e63e8d80e942fd32e6bbd662eba0134b262e9eb6c5e1e2d88"
    sha256 cellar: :any,                 arm64_monterey: "1ae417c7b858c45796f21a17159f21bde07a0e575318dca1757b92fb3b3e515c"
    sha256 cellar: :any,                 sonoma:         "7794d8c394ab444645e86b87a47a868fe82f16b0dcc13d596f684b62a2661c57"
    sha256 cellar: :any,                 ventura:        "01cea0389ed701926bb4141b810a244f9ac57dc43512855019fdf6f0586018a7"
    sha256 cellar: :any,                 monterey:       "acef2e25ab9ab0d53599d43b9f9043006fc0d071c24f3e7e4ef0128ff16319ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bcf694df57925d1e267cf9fec76c8495662950fd6008b9e29f9f754c8371320"
  end

  depends_on "cmake" => :build

  on_intel do
    # Required only for x86 SIMD extensions.
    depends_on "nasm" => :build
  end

  # These conflict with `jpeg`, which is now keg-only.
  link_overwrite "bin/cjpeg", "bin/djpeg", "bin/jpegtran", "bin/rdjpgcom", "bin/wrjpgcom"
  link_overwrite "include/jconfig.h", "include/jerror.h", "include/jmorecfg.h", "include/jpeglib.h"
  link_overwrite "lib/libjpeg.dylib", "lib/libjpeg.so", "lib/libjpeg.a", "lib/pkgconfig/libjpeg.pc"
  link_overwrite "share/man/man1/cjpeg.1", "share/man/man1/djpeg.1", "share/man/man1/jpegtran.1",
                 "share/man/man1/rdjpgcom.1", "share/man/man1/wrjpgcom.1"

  # Fix cmake build configuration for AppleClang, remove in next release
  # Relates to https://github.com/libjpeg-turbo/libjpeg-turbo/pull/755
  # Using an inline patch because upstream's patch doesn't apply cleanly on top of 3.0.2
  patch :DATA

  def install
    args = ["-DWITH_JPEG8=1", "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}"]
    # https://github.com/libjpeg-turbo/libjpeg-turbo/issues/709
    if Hardware::CPU.arm? && MacOS.version >= :ventura
      args += ["-DFLOATTEST8=fp-contract",
               "-DFLOATTEST12=fp-contract"]
    end
    # https://github.com/libjpeg-turbo/libjpeg-turbo/issues/734
    args << "-DFLOATTEST12=no-fp-contract" if Hardware::CPU.arm? && MacOS.version == :monterey
    args += std_cmake_args.reject { |arg| arg["CMAKE_INSTALL_LIBDIR"].present? }

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build", "--rerun-failed", "--output-on-failure", "--parallel", ENV.make_jobs
    system "cmake", "--install", "build"
  end

  test do
    system bin/"jpegtran", "-crop", "1x1",
                           "-transpose",
                           "-perfect",
                           "-outfile", "out.jpg",
                           test_fixtures("test.jpg")
    assert_predicate testpath/"out.jpg", :exist?
  end
end
__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index adb0ca45..f6980471 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -395,7 +395,7 @@ if(MSVC)
   add_definitions(-D_CRT_NONSTDC_NO_WARNINGS)
 endif()
 
-if(CMAKE_COMPILER_IS_GNUCC OR CMAKE_C_COMPILER_ID STREQUAL "Clang")
+if(CMAKE_COMPILER_IS_GNUCC OR CMAKE_C_COMPILER_ID MATCHES "Clang")
   # Use the maximum optimization level for release builds
   foreach(var CMAKE_C_FLAGS_RELEASE CMAKE_C_FLAGS_RELWITHDEBINFO)
     if(${var} MATCHES "-O2")
@@ -468,7 +468,7 @@ if(UNIX)
   endif()
 endif()
 
-if(NOT MSVC OR CMAKE_C_COMPILER_ID STREQUAL "Clang")
+if(NOT MSVC OR CMAKE_C_COMPILER_ID MATCHES "Clang")
   check_c_source_compiles("const int __attribute__((visibility(\"hidden\"))) table[1] = { 0 }; int main(void) { return table[0]; }"
     HIDDEN_WORKS)
   if(HIDDEN_WORKS)
@@ -907,7 +907,7 @@ if(CPU_TYPE STREQUAL "x86_64" OR CPU_TYPE STREQUAL "i386")
     set(DEFAULT_FLOATTEST8 no-fp-contract)
   endif()
 elseif(CPU_TYPE STREQUAL "powerpc" OR CPU_TYPE STREQUAL "arm64")
-  if(CMAKE_C_COMPILER_ID STREQUAL "Clang")
+  if(CMAKE_C_COMPILER_ID MATCHES "Clang")
     if(CMAKE_C_COMPILER_VERSION VERSION_EQUAL 14.0.0 OR
       CMAKE_C_COMPILER_VERSION VERSION_GREATER 14.0.0)
       set(DEFAULT_FLOATTEST8 fp-contract)
@@ -949,7 +949,7 @@ endif()
 if(CPU_TYPE STREQUAL "x86_64")
   set(DEFAULT_FLOATTEST12 no-fp-contract)
 elseif(CPU_TYPE STREQUAL "powerpc" OR CPU_TYPE STREQUAL "arm64")
-  if(CMAKE_C_COMPILER_ID STREQUAL "Clang")
+  if(CMAKE_C_COMPILER_ID MATCHES "Clang")
     if(CMAKE_C_COMPILER_VERSION VERSION_EQUAL 14.0.0 OR
       CMAKE_C_COMPILER_VERSION VERSION_GREATER 14.0.0)
       set(DEFAULT_FLOATTEST12 fp-contract)
@@ -1210,7 +1210,7 @@ foreach(libtype ${TEST_LIBTYPES})
       set(MD5_PPM_3x2_FLOAT_NO_FP_CONTRACT ${MD5_PPM_3x2_FLOAT_SSE})
       set(MD5_JPEG_3x2_FLOAT_PROG_FP_CONTRACT
         ${MD5_JPEG_3x2_FLOAT_PROG_NO_FP_CONTRACT})
-      if(CMAKE_C_COMPILER_ID STREQUAL "Clang")
+      if(CMAKE_C_COMPILER_ID MATCHES "Clang")
         set(MD5_PPM_3x2_FLOAT_FP_CONTRACT 2da9de6ae869e88b8372de815d366b03)
       else()
         set(MD5_PPM_3x2_FLOAT_FP_CONTRACT ${MD5_PPM_3x2_FLOAT_SSE})
@@ -1282,7 +1282,7 @@ foreach(libtype ${TEST_LIBTYPES})
       set(MD5_PPM_3x2_FLOAT_NO_FP_CONTRACT f6bfab038438ed8f5522fbd33595dcdc)
       set(MD5_JPEG_3x2_FLOAT_PROG_FP_CONTRACT
         ${MD5_JPEG_3x2_FLOAT_PROG_NO_FP_CONTRACT})
-      if(CMAKE_C_COMPILER_ID STREQUAL "Clang")
+      if(CMAKE_C_COMPILER_ID MATCHES "Clang")
         set(MD5_PPM_3x2_FLOAT_FP_CONTRACT ${MD5_PPM_3x2_FLOAT_NO_FP_CONTRACT})
       else()
         set(MD5_PPM_3x2_FLOAT_FP_CONTRACT 0e917a34193ef976b679a6b069b1be26)
