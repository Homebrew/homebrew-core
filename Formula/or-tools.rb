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
    sha256 cellar: :any,                 arm64_monterey: "f0281aa3585c24d9dd3c5df3b7aa76369b038f43ac0075185e66cd56e689fa4c"
    sha256 cellar: :any,                 arm64_big_sur:  "ff9b55d2576d5d5eb880fc9f947007e92a3532a7221169eee36bdb81be6ad901"
    sha256 cellar: :any,                 monterey:       "6e9e707a6bfaa9ef91fee6c842ed5b2e7558b7ad924eca82c63792a469abc4be"
    sha256 cellar: :any,                 big_sur:        "f34c901fc0a95da5c4c7dfd7877ceddd516f8006ac8d5fb8bd7998ed98dd55b6"
    sha256 cellar: :any,                 catalina:       "42c9d0b4b468ba1c4ad16eb512cdf3d06b7b6eeba86ef84290ac51f8e33314ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abed14d2017029233ae30b93815d3a6212ee80efea41d91acbfd1bb3e7b3ac13"
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
