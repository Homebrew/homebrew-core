class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/v9.1.tar.gz"
  sha256 "b51ca3b08f768de5a0c1029f7127264640e50d9c7b83383a175109ef213bd307"
  license "Apache-2.0"
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9029930836f9fd35b49b3b3ec2a2f3e2dac8bd6879168b84433be3c5119c0536"
    sha256 cellar: :any, monterey:      "1b6a64ab3510bc8e2e8b578eb8d8a58615d100519bb230007dc8a0aa835f7b1f"
    sha256 cellar: :any, big_sur:       "8c009bad27a131ab9fc5bec04f69ba1ea52c644415448aef82b363f3f94d3a42"
    sha256 cellar: :any, catalina:      "3da9d30729e68264508a4f2015029cb782acf58bd2fbf2a14bfc586fecf1b4f1"
    sha256 cellar: :any, mojave:        "9f6650ce096366942f5de4bf97ca02879303f21aa2562fee137d168eb3d75fc8"
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
