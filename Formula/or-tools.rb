class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://github.com/google/or-tools/archive/v9.6.tar.gz"
  sha256 "bc4b07dc9c23f0cca43b1f5c889f08a59c8f2515836b03d4cc7e0f8f2c879234"
  license "Apache-2.0"
  revision 1
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "03667fcef74df82288519510fa09a9233c7b4ccea32dc7990da8b9d446de66a2"
    sha256 cellar: :any,                 arm64_monterey: "87015bad81a137a3bdb8e73884cca022d2c3322fe0276190f676079bcb2a82c4"
    sha256 cellar: :any,                 arm64_big_sur:  "ba58c8993d3731bb172d9ab6dca7cdd755ab4878e9fc777f4dc0b93bf47dc733"
    sha256 cellar: :any,                 ventura:        "35a34d1f76fd577ea466205874de9b249984a67902c614fa87d151cfa6479946"
    sha256 cellar: :any,                 monterey:       "ecc9b9ae1176fc12aecd238c36bba1bc53d91abddd607ab3f7c2b61b0f25f4a3"
    sha256 cellar: :any,                 big_sur:        "34a7c0a846c18550ad7ee7228c1b19edc923aa67c7811e2fec6e2e164c4d7b57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec8228719f2f644bef95cef3a0678ff5b72f51d35bdbea097561a649fc92b25b"
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
  depends_on "protobuf@21"
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
    # manual protobuf includes can be removed when this uses unversioned protobuf.
    # Linear Solver & Glop Solver
    system ENV.cxx, "-std=c++17", "-I#{Formula["protobuf@21"].opt_include}", pkgshare/"simple_lp_program.cc",
           "-I#{include}", "-L#{lib}", "-lortools",
           *shell_output("pkg-config --cflags --libs absl_check absl_log").chomp.split,
           "-o", "simple_lp_program"
    system "./simple_lp_program"

    # Routing Solver
    system ENV.cxx, "-std=c++17", "-I#{Formula["protobuf@21"].opt_include}", pkgshare/"simple_routing_program.cc",
           "-I#{include}", "-L#{lib}", "-lortools",
           *shell_output("pkg-config --cflags --libs absl_check absl_log").chomp.split,
           "-o", "simple_routing_program"
    system "./simple_routing_program"

    # Sat Solver
    system ENV.cxx, "-std=c++17", "-I#{Formula["protobuf@21"].opt_include}", pkgshare/"simple_sat_program.cc",
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
