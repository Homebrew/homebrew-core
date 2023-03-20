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
    sha256 cellar: :any,                 arm64_ventura:  "0d822b8c261e0bbb33c58f3c783c56beebf2a1cd606654926f267630573de915"
    sha256 cellar: :any,                 arm64_monterey: "15cbd9f44e5c07072cc5ca8cf3e1e29a266d7366a73af937e6c9e67a37c765ba"
    sha256 cellar: :any,                 arm64_big_sur:  "367007d1964b818761c6b51b404cb75a86c05e98e83dc59c01bcb9e10b8dd500"
    sha256 cellar: :any,                 ventura:        "c2f440e0ff49ee1a51fd920ae42d4e9d37e31594befcac47911d602ade0e9a90"
    sha256 cellar: :any,                 monterey:       "2ac4b800fd5e041fc47d2e8b1d7449048f18a2ee7171e90cc5de9dd3a50fcd8b"
    sha256 cellar: :any,                 big_sur:        "6fe28066976797a12e7fa15ac47f1ee8640483dc2057f454506baf52b9073689"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a96970f1b7cc4b252dfc0fc79740500afb8fcb70fb0d8b3ae50c2c565efbf49b"
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
