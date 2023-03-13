class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/v9.6.tar.gz"
  sha256 "bc4b07dc9c23f0cca43b1f5c889f08a59c8f2515836b03d4cc7e0f8f2c879234"
  license "Apache-2.0"
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c429d8b9808386c9f144463bd2f8afb14da34624e8521be1e53a55fd7a01ab11"
    sha256 cellar: :any,                 arm64_monterey: "4ef792b8d4796c04e5537bfb89825f00d87886e58423af0e40e884519cf655bd"
    sha256 cellar: :any,                 arm64_big_sur:  "cfb6281f645b4e46fb29c9eba26b4bb8cdd013ffb236077ee3f73151e9fc280e"
    sha256 cellar: :any,                 ventura:        "2db38168d02bba4b2789bc669c1a92cb509320340e5a263c69cdbe29df7d2f26"
    sha256 cellar: :any,                 monterey:       "2161939c2fb494d0759afef4cb2438721a69dfeaa65f2a8025af79cd858f9468"
    sha256 cellar: :any,                 big_sur:        "d57db4e441107118b75511f45ff0ead435892bd888586ab4f7d559836fee5977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99c78e688c9c4cefcbdf6ef6cfc264968dac3d9e47d153c846a30f0f4ef0f2f1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => [:build, :test]
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
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "ortools/linear_solver/samples/simple_lp_program.cc"
    pkgshare.install "ortools/constraint_solver/samples/simple_routing_program.cc"
    pkgshare.install "ortools/sat/samples/simple_sat_program.cc"
  end

  test do
    # Linear Solver & Glop Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_lp_program.cc",
           "-I#{include}", "-L#{lib}", "-lortools",
           *shell_output("pkg-config --cflags --libs absl_check absl_log").chomp.split,
           "-o", "simple_lp_program"
    system "./simple_lp_program"

    # Routing Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_routing_program.cc",
           "-I#{include}", "-L#{lib}", "-lortools",
           *shell_output("pkg-config --cflags --libs absl_check absl_log").chomp.split,
           "-o", "simple_routing_program"
    system "./simple_routing_program"

    # Sat Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_sat_program.cc",
           "-I#{include}", "-L#{lib}", "-lortools",
           *shell_output("pkg-config --cflags --libs absl_log absl_raw_hash_set").chomp.split,
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
