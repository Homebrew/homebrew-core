class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/v9.4.tar.gz"
  sha256 "180fbc45f6e5ce5ff153bea2df0df59b15346f2a7f8ffbd7cb4aed0fb484b8f6"
  license "Apache-2.0"
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "70bc042453a171a4ddfc617431495877022c3c9b39cf20e6b36977758e8b11e4"
    sha256 cellar: :any,                 arm64_big_sur:  "d7051adeec3d981e66813c1041c60772f4de566e024964f383fe9c42b65daf61"
    sha256 cellar: :any,                 monterey:       "d76faae4705c9f29fe71cf0daf2d50157f8daf0dfb1800b03ff58c0b8ed9f62f"
    sha256 cellar: :any,                 big_sur:        "3a88edaf5a3fdb34afe1202790fac3157a45d9dfdde3b48f2256d195e58d3bc5"
    sha256 cellar: :any,                 catalina:       "3cbf768fb36c903c77c3d35f5f818fb9d87c00128dfa5a8dcc4b579845c496f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "619a54c8667620263c8d35ed08fd1ac8104ca4abef13bfa08efb94a21a1fc327"
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

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

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
    system ENV.cxx, "-std=c++17",
           "-I#{include}", "-L#{lib}", "-lortools",
           "-L#{Formula["abseil"].opt_lib}", "-labsl_time",
           pkgshare/"simple_lp_program.cc", "-o", "simple_lp_program"
    system "./simple_lp_program"
    # Routing Solver
    system ENV.cxx, "-std=c++17",
           "-I#{include}", "-L#{lib}", "-lortools",
           pkgshare/"simple_routing_program.cc", "-o", "simple_routing_program"
    system "./simple_routing_program"
    # Sat Solver
    system ENV.cxx, "-std=c++17",
           "-I#{include}", "-L#{lib}", "-lortools",
           "-L#{Formula["abseil"].opt_lib}", "-labsl_raw_hash_set",
           pkgshare/"simple_sat_program.cc", "-o", "simple_sat_program"
    system "./simple_sat_program"
  end
end
