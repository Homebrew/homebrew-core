class Arrayfire < Formula
  desc "General purpose GPU library"
  homepage "https://arrayfire.com"
  url "https://github.com/arrayfire/arrayfire/releases/download/v3.9.0/arrayfire-full-3.9.0.tar.bz2"
  sha256 "8356c52bf3b5243e28297f4b56822191355216f002f3e301d83c9310a4b22348"
  license "BSD-3-Clause"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_sequoia: "bdc90c11320a6266ef4de580089a04b8c4b2b3dab9ae984c910d631a8c1eea15"
    sha256 cellar: :any, arm64_sonoma:  "149b7225e5e5c90272b2a85b530ebc8f70a3c05b8c55af6c14f352d03846400c"
    sha256 cellar: :any, arm64_ventura: "22a13f617fea6ec5e17cd2caa9c95712c6721a594a5a7d80ba4740a35564aadc"
    sha256 cellar: :any, sonoma:        "ef92a75a71d09d7f9912e91a39ec319fb5b34ab7361b4d0f4c85c874de3d7cf4"
    sha256 cellar: :any, ventura:       "6a38a6cba73cf3e95c639d4763081c1bedf867a0e817982cefbbac4ae1e00465"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "fftw"
  depends_on "fmt"
  depends_on "freeimage"
  depends_on "openblas"
  depends_on "spdlog"

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "opencl-icd-loader"
    depends_on "pocl"
  end

  # fmt 11 compatibility
  # https://github.com/arrayfire/arrayfire/issues/3596
  patch :DATA

  def install
    # Fix for: `ArrayFire couldn't locate any backends.`
    rpaths = [
      rpath(source: lib, target: Formula["fftw"].opt_lib),
      rpath(source: lib, target: Formula["openblas"].opt_lib),
      rpath(source: lib, target: HOMEBREW_PREFIX/"lib"),
    ]

    if OS.mac?
      # Our compiler shims strip `-Werror`, which breaks upstream detection of linker features.
      # https://github.com/arrayfire/arrayfire/blob/715e21fcd6e989793d01c5781908f221720e7d48/src/backend/opencl/CMakeLists.txt#L598
      inreplace "src/backend/opencl/CMakeLists.txt", "if(group_flags)", "if(FALSE)"
    else
      # Work around missing include for climits header
      # Issue ref: https://github.com/arrayfire/arrayfire/issues/3543
      ENV.append "CXXFLAGS", "-include climits"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DAF_BUILD_CUDA=OFF",
                    "-DAF_COMPUTE_LIBRARY=FFTW/LAPACK/BLAS",
                    "-DCMAKE_CXX_STANDARD=14",
                    "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/helloworld/helloworld.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laf", "-lafcpu", "-o", "test"
    # OpenCL does not work in CI.
    return if Hardware::CPU.arm? && OS.mac? && MacOS.version >= :monterey && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "ArrayFire v#{version}", shell_output("./test")
  end
end

__END__
diff --git a/src/backend/common/jit/NodeIO.hpp b/src/backend/common/jit/NodeIO.hpp
index ac149d9..edffdfa 100644
--- a/src/backend/common/jit/NodeIO.hpp
+++ b/src/backend/common/jit/NodeIO.hpp
@@ -16,7 +16,7 @@
 template<>
 struct fmt::formatter<af::dtype> : fmt::formatter<char> {
     template<typename FormatContext>
-    auto format(const af::dtype& p, FormatContext& ctx) -> decltype(ctx.out()) {
+    auto format(const af::dtype& p, FormatContext& ctx) const -> decltype(ctx.out()) {
         format_to(ctx.out(), "{}", arrayfire::common::getName(p));
         return ctx.out();
     }
@@ -58,7 +58,7 @@ struct fmt::formatter<arrayfire::common::Node> {
     // Formats the point p using the parsed format specification (presentation)
     // stored in this formatter.
     template<typename FormatContext>
-    auto format(const arrayfire::common::Node& node, FormatContext& ctx)
+    auto format(const arrayfire::common::Node& node, FormatContext& ctx) const
         -> decltype(ctx.out()) {
         // ctx.out() is an output iterator to write to.

diff --git a/src/backend/common/ArrayFireTypesIO.hpp b/src/backend/common/ArrayFireTypesIO.hpp
index e7a2e08..5da74a9 100644
--- a/src/backend/common/ArrayFireTypesIO.hpp
+++ b/src/backend/common/ArrayFireTypesIO.hpp
@@ -21,7 +21,7 @@ struct fmt::formatter<af_seq> {
     }

     template<typename FormatContext>
-    auto format(const af_seq& p, FormatContext& ctx) -> decltype(ctx.out()) {
+    auto format(const af_seq& p, FormatContext& ctx) const -> decltype(ctx.out()) {
         // ctx.out() is an output iterator to write to.
         if (p.begin == af_span.begin && p.end == af_span.end &&
             p.step == af_span.step) {
@@ -73,18 +73,16 @@ struct fmt::formatter<arrayfire::common::Version> {
     }

     template<typename FormatContext>
-    auto format(const arrayfire::common::Version& ver, FormatContext& ctx)
+    auto format(const arrayfire::common::Version& ver, FormatContext& ctx) const
         -> decltype(ctx.out()) {
         if (ver.major() == -1) return format_to(ctx.out(), "N/A");
-        if (ver.minor() == -1) show_minor = false;
-        if (ver.patch() == -1) show_patch = false;
-        if (show_major && !show_minor && !show_patch) {
+        if (show_major && (ver.minor() == -1) && (ver.patch() == -1)) {
             return format_to(ctx.out(), "{}", ver.major());
         }
-        if (show_major && show_minor && !show_patch) {
+        if (show_major && (ver.minor() != -1) && (ver.patch() == -1)) {
             return format_to(ctx.out(), "{}.{}", ver.major(), ver.minor());
         }
-        if (show_major && show_minor && show_patch) {
+        if (show_major && (ver.minor() != -1) && (ver.patch() != -1)) {
             return format_to(ctx.out(), "{}.{}.{}", ver.major(), ver.minor(),
                              ver.patch());
         }
diff --git a/src/backend/common/debug.hpp b/src/backend/common/debug.hpp
index 54e74a2..07fa589 100644
--- a/src/backend/common/debug.hpp
+++ b/src/backend/common/debug.hpp
@@ -12,6 +12,7 @@
 #include <boost/stacktrace.hpp>
 #include <common/ArrayFireTypesIO.hpp>
 #include <common/jit/NodeIO.hpp>
+#include <fmt/ranges.h>
 #include <spdlog/fmt/bundled/format.h>
 #include <iostream>

diff --git a/src/backend/opencl/compile_module.cpp b/src/backend/opencl/compile_module.cpp
index 89d382c..2c979fd 100644
--- a/src/backend/opencl/compile_module.cpp
+++ b/src/backend/opencl/compile_module.cpp
@@ -22,6 +22,8 @@
 #include <platform.hpp>
 #include <traits.hpp>

+#include <fmt/ranges.h>
+
 #include <algorithm>
 #include <cctype>
 #include <cstdio>
