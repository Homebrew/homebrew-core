class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/v8.1.tar.gz"
  sha256 "beb9fe379977033151045d0815d26c628ad99d74d68b9f3b707578492723731e"
  license "Apache-2.0"
  head "https://github.com/google/or-tools.git"

  livecheck do
    url "https://github.com/google/or-tools/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "07a181c96be3b85baae0733608951628fcfc6d3e4aa7d867a54d2eb0d7e5bf0c" => :big_sur
    sha256 "228404a86e3474bc2db1ab8c30344385d2f25e147ce5dbeabd7f8b3d4c80630c" => :catalina
    sha256 "e2fd75040b662a648b7b38003f8bd3e275ad8ac0aab8d8bbdcef34f0e9e90316" => :mojave
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
