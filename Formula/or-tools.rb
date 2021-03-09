class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/v8.2.tar.gz"
  sha256 "cf40715fa5cfeee88e2c8f5583465182c8dedf60b4eb7c4a967b32ff61ac4302"
  license "Apache-2.0"
  head "https://github.com/google/or-tools.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "54e3a32443a0b8802b76ce806d3203c5967cf153840413191abbc93ea22413db"
    sha256 cellar: :any, big_sur:       "390ac146a2989012d3e0b52733de51f2f2f738923406ccfb11696d86b7bda6e3"
    sha256 cellar: :any, catalina:      "c7c2951c6d072664e3e3974fee2a87f6354ad7c9765257999e5ae85d82f8594e"
    sha256 cellar: :any, mojave:        "88c19f66797c8832956fd3c00e92692a131fd22c64925ddcc46894cba0fc2aae"
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
