class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/v9.5.tar.gz"
  sha256 "57f81b94949d35dc042690db3fa3f53245cffbf6824656e1a03f103a3623c939"
  license "Apache-2.0"
  revision 2
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "34672a686112e2ab7442f8de1797bc05687293a4944e8842c608d2a41afe4874"
    sha256 cellar: :any,                 arm64_monterey: "3ced7d174d313cde8a5b20e927874bbdd6b6da06ec3b8cc0df7f0fdc3c9a95fc"
    sha256 cellar: :any,                 arm64_big_sur:  "8ac085ee9c00cffe72f5a3bb0c1dd408e6db905a47e44a74fd6c71fb29b25a4c"
    sha256 cellar: :any,                 ventura:        "b0fc71da27ce2eeb84543019cbac3297e40ce518fadacb854d4cc788844a3f82"
    sha256 cellar: :any,                 monterey:       "d3f678e1e2bc35aaac3fcb0681e23eb2a988c07fa8e8192c093d11bce2942967"
    sha256 cellar: :any,                 big_sur:        "5232b03160dc6e21ae602a961dec8c016bfb68a260ed00609a33332c870acd48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f6eb897000a0ec9c357d25be591587c9030ecbb660e602f8800039876b0b200"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "eigen"
  depends_on "openblas"
  depends_on "osi"
  depends_on "protobuf"
  depends_on "re2"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  # Add missing <errno.h> include to numbers.cc
  patch :DATA

  def install
    args = %w[
      -DUSE_SCIP=OFF
      -DBUILD_SAMPLES=OFF
      -DBUILD_EXAMPLES=OFF
    ]

    # Support ABSL_LEGACY_THREAD_ANNOTATIONS, https://github.com/google/or-tools/issues/3655
    # remove in next release
    args << "-DCMAKE_CXX_FLAGS=-DABSL_LEGACY_THREAD_ANNOTATIONS"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "-v"
    system "cmake", "--build", "build", "--target", "install"
    pkgshare.install "ortools/linear_solver/samples/simple_lp_program.cc"
    pkgshare.install "ortools/constraint_solver/samples/simple_routing_program.cc"
    pkgshare.install "ortools/sat/samples/simple_sat_program.cc"
  end

  test do
    # Linear Solver & Glop Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_lp_program.cc",
           "-I#{include}", "-L#{lib}", "-lortools",
           "-L#{Formula["abseil"].opt_lib}", "-labsl_time",
           "-o", "simple_lp_program"
    system "./simple_lp_program"
    # Routing Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_routing_program.cc",
           "-I#{include}", "-L#{lib}", "-lortools",
           "-o", "simple_routing_program"
    system "./simple_routing_program"
    # Sat Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_sat_program.cc",
           "-I#{include}", "-L#{lib}", "-lortools",
           "-L#{Formula["abseil"].opt_lib}", "-labsl_raw_hash_set",
           "-o", "simple_sat_program"
    system "./simple_sat_program"
  end
end

__END__
diff --git a/ortools/base/numbers.cc b/ortools/base/numbers.cc
index e9f5a57..e49182c 100644
--- a/ortools/base/numbers.cc
+++ b/ortools/base/numbers.cc
@@ -16,6 +16,7 @@

 #include "ortools/base/numbers.h"

+#include <errno.h>
 #include <cfloat>
 #include <cstdint>
 #include <cstdlib>
