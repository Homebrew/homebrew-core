class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/v9.5.tar.gz"
  sha256 "57f81b94949d35dc042690db3fa3f53245cffbf6824656e1a03f103a3623c939"
  license "Apache-2.0"
  revision 1
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "baddd8d5c3eb20f166a85d795b67b60e5c75945d738f3cb0137147be10bab316"
    sha256 cellar: :any,                 arm64_monterey: "8f605dba57dd4850ad32e4d95285e44d0ae192abc6728167ee9fd5c24b988928"
    sha256 cellar: :any,                 arm64_big_sur:  "c7326590c08eefb95b73f5230a6394e0bebd57938bb2cee99798a334a8caedc9"
    sha256 cellar: :any,                 ventura:        "9dc38d19ceb0b1bb05716723077181b3a160d8c3e9a51be03f9a49564608c083"
    sha256 cellar: :any,                 monterey:       "220d96540bdf2ff9cab1ad92f5155c9e7998d1b5422442fba6074bea8c503c47"
    sha256 cellar: :any,                 big_sur:        "b3a9688ad478dd85dd31fbe799d8485a36fa0433708bb4302f9861c5963cc9c7"
    sha256 cellar: :any,                 catalina:       "7306e6af086762473674045332bcc76c4db17e3c198c0f26632b2f5727eface0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5481985292ba36a541c3d37bc00e343669b21d17e582a9c2d87bc31a03ccac8"
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
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DUSE_SCIP=OFF",
                    "-DBUILD_SAMPLES=OFF",
                    "-DBUILD_EXAMPLES=OFF"
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
