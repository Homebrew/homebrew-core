class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/v9.2.tar.gz"
  sha256 "5337935ea1fa010bb62cf0fc8bedd6de07dda77bff3db7a0f6a36c84c7bd58db"
  license "Apache-2.0"
  revision 1
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "3aae502a74d30759d8a518b7de009d8354a577270472d8c0002b9a0cae377ec4"
    sha256 cellar: :any, arm64_big_sur:  "36656159c53b4cf21a316c6c0879ebce2da9f74b6b3653c604b7da1f2c353a7c"
    sha256 cellar: :any, monterey:       "97259eba24d02f4c888d88f71f764704ff4ebaa5be9b9cfc6ca55f3d1814de7e"
    sha256 cellar: :any, big_sur:        "94ed3b244cdb4b8e02ba4691da15a717874338eba8af25822b09a47f2f6ed428"
    sha256 cellar: :any, catalina:       "668ae59a10c96f8076791de2c0df9ea35c35116f186a741fa108f9cd222e26ee"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "osi"
  depends_on "protobuf"

  def install
    system "cmake", "-S.", "-Bbuild", *std_cmake_args,
           "-DUSE_SCIP=OFF", "-DBUILD_SAMPLES=OFF", "-DBUILD_EXAMPLES=OFF"
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
           pkgshare/"simple_sat_program.cc", "-o", "simple_sat_program"
    system "./simple_sat_program"
  end
end
