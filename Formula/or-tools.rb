class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/v8.0.tar.gz"
  sha256 "ac01d7ebde157daaeb0e21ce54923a48e4f1d21faebd0b08a54979f150f909ee"
  license "Apache-2.0"
  head "https://github.com/google/or-tools.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "7a119a20186b34d80b7a36e3cd18f2e7bc6561cd70e52ea05231422a38fdcd1f" => :catalina
    sha256 "61e99ba40756cdc5d4fd5cbff6efc8ed3bf82ea187396895f0e310946105591a" => :mojave
    sha256 "f5b9f71179930075b58dcc26f0ebe69a4ae34e7f528347f685116690cc23089d" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "gflags"
  depends_on "glog"
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
           "-L#{Formula["gflags"].opt_lib}", "-lgflags",
           "-L#{Formula["glog"].opt_lib}", "-lglog",
           pkgshare/"simple_lp_program.cc", "-o", "simple_lp_program"
    system "./simple_lp_program"
    # Routing Solver
    system ENV.cxx, "-std=c++17",
           "-I#{include}", "-L#{lib}", "-lortools",
           "-L#{Formula["gflags"].opt_lib}", "-lgflags",
           "-L#{Formula["glog"].opt_lib}", "-lglog",
           pkgshare/"simple_routing_program.cc", "-o", "simple_routing_program"
    system "./simple_routing_program"
    # Sat Solver
    system ENV.cxx, "-std=c++17",
           "-I#{include}", "-L#{lib}", "-lortools",
           "-L#{Formula["gflags"].opt_lib}", "-lgflags",
           "-L#{Formula["glog"].opt_lib}", "-lglog",
           pkgshare/"simple_sat_program.cc", "-o", "simple_sat_program"
    system "./simple_sat_program"
  end
end
