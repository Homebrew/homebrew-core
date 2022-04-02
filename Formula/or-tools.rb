class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/v9.2.tar.gz"
  sha256 "5337935ea1fa010bb62cf0fc8bedd6de07dda77bff3db7a0f6a36c84c7bd58db"
  license "Apache-2.0"
  revision 3
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "02a9fbeef13c7d71d23e90813d2146839d27a33bb7505ad7b9fa5307e417103e"
    sha256 cellar: :any,                 arm64_big_sur:  "c444da980eb616ab64cbff22a3ca3ce3d3b63ddf12d3cce759e18927f232eb7b"
    sha256 cellar: :any,                 monterey:       "76da45521f1c59e6f743946fef2423dd87b7fb1f22cfc9b41fa2cd90cac422f5"
    sha256 cellar: :any,                 big_sur:        "53f217259a3740dadce9070892a9119203a96f17040aa11109791bda6ee0993d"
    sha256 cellar: :any,                 catalina:       "8dd8f31ead4765391179b20f26e735e3fbbe3e25f52fe05ba89483badfb8bb12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efe55ab7e49dc5d27d859137b9151dcc045da0c8a1bf28032a26df451cfc554f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "openblas"
  depends_on "osi"
  depends_on "protobuf"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

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
           "-L#{Formula["abseil"].opt_lib}", "-labsl_raw_hash_set",
           pkgshare/"simple_sat_program.cc", "-o", "simple_sat_program"
    system "./simple_sat_program"
  end
end
