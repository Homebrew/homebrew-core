class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/refs/tags/v9.8.tar.gz"
  sha256 "85e10e7acf0a9d9a3b891b9b108f76e252849418c6230daea94ac429af8a4ea4"
  license "Apache-2.0"
  revision 3
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c9d929f66914073437b2916cd629b100533bcbb6762858c9e822d60b132e3277"
    sha256 cellar: :any,                 arm64_ventura:  "2178c626c083b07c754e6f33fd99f1be4867e0c5eba7257fa0cdcedea0f87ad5"
    sha256 cellar: :any,                 arm64_monterey: "c887293d618f430f374d2b1cdf46ab93817f12fedda855bb370caa8e795e8a43"
    sha256 cellar: :any,                 sonoma:         "b518b5485f5e725b050fcec7c3a6c92c851b8f333aa1d8c22dad7b41a024b4f9"
    sha256 cellar: :any,                 ventura:        "4ba7ff96be196dd6f91ade4dd76f40709ed60055acd84f20c89365ed423a4dde"
    sha256 cellar: :any,                 monterey:       "6fc7e67726e682cdd840683764d327fd0ad3247074ea4685c53acc794328aad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b968071b9cc2ec0fd6bfa7d3990dd2933bd2a5633886f81d881629c242c1a15a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => [:build, :test]
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
    args = %w[
      -DUSE_SCIP=OFF
      -DBUILD_SAMPLES=OFF
      -DBUILD_EXAMPLES=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "ortools/linear_solver/samples/simple_lp_program.cc"
    pkgshare.install "ortools/constraint_solver/samples/simple_routing_program.cc"
    pkgshare.install "ortools/sat/samples/simple_sat_program.cc"
  end

  test do
    # Linear Solver & Glop Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_lp_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    *shell_output("pkg-config --cflags --libs absl_check absl_log").chomp.split,
                    "-o", "simple_lp_program"
    system "./simple_lp_program"

    # Routing Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_routing_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    *shell_output("pkg-config --cflags --libs absl_check absl_log").chomp.split,
                    "-o", "simple_routing_program"
    system "./simple_routing_program"

    # Sat Solver
    system ENV.cxx, "-std=c++17", pkgshare/"simple_sat_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    *shell_output("pkg-config --cflags --libs absl_log absl_raw_hash_set").chomp.split,
                    "-o", "simple_sat_program"
    system "./simple_sat_program"
  end
end
