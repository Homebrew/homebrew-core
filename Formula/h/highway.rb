class Highway < Formula
  desc "Performance-portable, length-agnostic SIMD with runtime dispatch"
  homepage "https://github.com/google/highway"
  url "https://github.com/google/highway/archive/refs/tags/1.2.0.tar.gz"
  sha256 "7e0be78b8318e8bdbf6fa545d2ecb4c90f947df03f7aadc42c1967f019e63343"
  license "Apache-2.0"
  head "https://github.com/google/highway.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8a3327629482279fdff46b5bf3324cb6379a975b271d1ecc4a901a3cdb7e7f5a"
    sha256 cellar: :any,                 arm64_sonoma:   "406c96cf28555eb84e1c67788db50223a6af2fd488ce91e831068e60981d128a"
    sha256 cellar: :any,                 arm64_ventura:  "26b4d20fb463b4a30a66a9bb8bf0e6bdac663b6c2ffe741652e671d20142a07b"
    sha256 cellar: :any,                 arm64_monterey: "7895ad60eb76fe27a6e954f30f00db408883a5fc90965d8802b6094d62b98bff"
    sha256 cellar: :any,                 sonoma:         "dd94650f29c85c1e1ed4343d1b3689161671586d2c19d14a42409c383ff0f456"
    sha256 cellar: :any,                 ventura:        "30ed68093b0816c5f0de2e504c299fb0981004b165dc75cae08a669f7cecfbbe"
    sha256 cellar: :any,                 monterey:       "4f27b99b7df6a54abf3aad7e2636f8947001518a057f385920f5d3c26b742e00"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2396e123e8890890de1977e2991632fead58fd6bbd427aa27d343755f24417c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dfee6723c0915e37b9253347c24bca7a2e37f0823a2e2883449c58a77ff32b6"
  end

  depends_on "cmake" => :build

  # These used to be bundled with `jpeg-xl`.
  link_overwrite "include/hwy/*", "lib/pkgconfig/libhwy*"

  # Avoid compiling ARM SVE on Apple Silicon
  # Issue ref: https://github.com/google/highway/issues/2317
  patch :DATA

  def install
    ENV.runtime_cpu_detection
    system "cmake", "-S", ".", "-B", "builddir",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DHWY_ENABLE_TESTS=OFF",
                    "-DHWY_ENABLE_EXAMPLES=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
    (share/"hwy").install "hwy/examples"
  end

  test do
    system ENV.cxx, "-std=c++11", "-I#{share}", "-I#{include}",
                    share/"hwy/examples/benchmark.cc", "-L#{lib}", "-lhwy"
    system "./a.out"
  end
end

__END__
diff --git a/hwy/detect_targets.h b/hwy/detect_targets.h
index a8d4a13f..e0ffb33a 100644
--- a/hwy/detect_targets.h
+++ b/hwy/detect_targets.h
@@ -223,8 +223,12 @@
 #endif

 // SVE[2] require recent clang or gcc versions.
+//
+// SVE is not supported on Apple arm64 CPUs and also crashes the compiler:
+// https://github.com/llvm/llvm-project/issues/97198
 #if (HWY_COMPILER_CLANG && HWY_COMPILER_CLANG < 1100) || \
-    (HWY_COMPILER_GCC_ACTUAL && HWY_COMPILER_GCC_ACTUAL < 1000)
+    (HWY_COMPILER_GCC_ACTUAL && HWY_COMPILER_GCC_ACTUAL < 1000) || \
+    (HWY_OS_APPLE && HWY_ARCH_ARM_A64)
 #define HWY_BROKEN_SVE (HWY_SVE | HWY_SVE2 | HWY_SVE_256 | HWY_SVE2_128)
 #else
 #define HWY_BROKEN_SVE 0
