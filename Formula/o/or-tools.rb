class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/refs/tags/v9.11.tar.gz"
  sha256 "f6a0bd5b9f3058aa1a814b798db5d393c31ec9cbb6103486728997b49ab127bc"
  license "Apache-2.0"
  revision 8
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8bc0f154bd8ff5f8b52a8ce5e7464c1d53cdcf6a5418d633502645c3fd66b4dd"
    sha256 cellar: :any,                 arm64_sonoma:  "3dcbf65d964704779f14c14b20f86014fced57438d169a50c3bbba0bcae00022"
    sha256 cellar: :any,                 arm64_ventura: "8bc94a0ec0b40991e4044d3361e88380c9be48f3a8eb5b9bb2c915dfd2c5891b"
    sha256 cellar: :any,                 sonoma:        "d62f64f14cab6e8fecc648a8891cce343c8185ae3d1165be7666a88aeedd1e0c"
    sha256 cellar: :any,                 ventura:       "3deca1cee3cf7498faed2c5c0dd968fa6544c4c6fd7bfb218f0e88a4be701d41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2163e77817e35fafb0b95d956d7eb14286004689c4b9fc1656bf767e0f05b442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64e9589608bbe0fd1ebd91e3e94a62502d48a880437d695d377b6671c223dc24"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => [:build, :test]
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
  depends_on "scip"
  uses_from_macos "zlib"

  # Add missing `#include`s to fix incompatibility with `abseil` 20240722.0.
  # https://github.com/google/or-tools/pull/4339
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/bb1af4bcb2ac8b2af4de4411d1ce8a6876ed9c15/or-tools/abseil-vlog-is-on.patch"
    sha256 "0f8f28e7363a36c6bafb9b60dc6da880b39d5b56d8ead350f27c8cb1e275f6b6"
  end

  def install
    # FIXME: Upstream enabled Highs support in their binary distribution, but our build fails with it.
    args = %w[
      -DUSE_HIGHS=OFF
      -DBUILD_DEPS=OFF
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
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.14)
      project(test LANGUAGES CXX)
      find_package(ortools CONFIG REQUIRED)
      add_executable(simple_lp_program #{pkgshare}/simple_lp_program.cc)
      target_compile_features(simple_lp_program PUBLIC cxx_std_17)
      target_link_libraries(simple_lp_program PRIVATE ortools::ortools)
    CMAKE
    cmake_args = []
    build_env = {}
    if OS.mac?
      build_env["CPATH"] = nil
    else
      cmake_args << "-DCMAKE_BUILD_RPATH=#{lib};#{HOMEBREW_PREFIX}/lib"
    end
    with_env(build_env) do
      system "cmake", "-S", ".", "-B", ".", *cmake_args, *std_cmake_args
      system "cmake", "--build", "."
    end
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
                    *shell_output("pkg-config --cflags --libs absl_check absl_log absl_raw_hash_set").chomp.split,
                    "-o", "simple_sat_program"
    system "./simple_sat_program"
  end
end
