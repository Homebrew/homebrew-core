class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/v8.1.tar.gz"
  sha256 "beb9fe379977033151045d0815d26c628ad99d74d68b9f3b707578492723731e"
  license "Apache-2.0"
  head "https://github.com/google/or-tools.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "225e9d0e06a0d60d66d474d5b567d35b918726763f0a5220bd31715118ec8a0b" => :big_sur
    sha256 "26aaa8b0bbea0325a86e44f76b2e1ebcb0be6f44e6448658b81d663821101b38" => :catalina
    sha256 "98261b04fd5559a35aa399d01a6f1f806212b0c06445c46ba0ea5f677b5257aa" => :mojave
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
