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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "2f44fbc89437e64a3129ba7ce90f1d3451d8aa46a8ab8ea4c267d202e0c6631a"
    sha256 cellar: :any,                 arm64_monterey: "20bc508ae78b76ad3d9a45ccc33b990d526813b3a4b8c14d7442368723613c51"
    sha256 cellar: :any,                 arm64_big_sur:  "002887469e355d785e7ca16f6932e0218f151a2344977f2c5506105d0d1744c7"
    sha256 cellar: :any,                 ventura:        "0f4f363eec2d21271aa421c66cd3f41b75b8a6a65799e163d2898f5313822a80"
    sha256 cellar: :any,                 monterey:       "5f80b6b6fede8324e9cd53558057eb47d5e91081af7098db4f93e1e67b280a9e"
    sha256 cellar: :any,                 big_sur:        "8a3a5a7b988dbcff82875424e90b4e625290f4c9a101a89c93815d9121da12b4"
    sha256 cellar: :any,                 catalina:       "8beb1393eb22e984c9d715ff94f1b63d3a16b21ee5d50e6eb7595a491387ca68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baf89a9af23e9ddf7dfae1d113cba8a751b676a73bac5b38272117488fd8beac"
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
    system ENV.cxx, "-std=c++17", pkgshare/"simple_lp_program.cc",
           "-I#{include}", "-L#{lib}", "-lortools",
           "-L#{Formula["abseil"].opt_lib}", "-labsl_time",
           "-o", "simple_lp_program"
    system "./simple_lp_program"
    # Routing Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_routing_program.cc",
           "-I#{include}", "-L#{lib}", "-lortools",
           "-o", "simple_routing_program"
    system "./simple_routing_program"
    # Sat Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_sat_program.cc",
           "-I#{include}", "-L#{lib}", "-lortools",
           "-L#{Formula["abseil"].opt_lib}", "-labsl_raw_hash_set",
           "-o", "simple_sat_program"
    system "./simple_sat_program"
  end
end
