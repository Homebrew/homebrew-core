class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/refs/tags/v9.9.tar.gz"
  sha256 "8c17b1b5b05d925ed03685522172ca87c2912891d57a5e0d5dcaeff8f06a4698"
  license "Apache-2.0"
  revision 1
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "16002ea5a510050c91f23a94a31126d7b5cc9b91b9d59d5899f4e20e1c15141a"
    sha256 cellar: :any,                 arm64_ventura:  "f4882d250666ada7cef20183be163d7f62b0d55cfa5a0041df31627353c6a028"
    sha256 cellar: :any,                 arm64_monterey: "54b1efe09dad109dde7c5d25d44fed263c87d197146f292fa7ba1063c554331e"
    sha256 cellar: :any,                 sonoma:         "25dd1d7b9dd7b1492ea26dc2013e592721d449090b8c6b351399dadad2a717ae"
    sha256 cellar: :any,                 ventura:        "ca3cc75acc876f9d50746bddf0d94ff984f068cd1b180c11ed3a0697085c32b5"
    sha256 cellar: :any,                 monterey:       "381da1388883f7996e8828fb5f5dd9b68967d828843e70788c938294ae708fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "587e8b0fbd6dceb2b4738dd9652bea93e36a0eb22499a71c5b66fe785233cfcb"
  end

  depends_on "cmake" => [:build, :test]
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

  # Backport fix for Protobuf 26
  patch do
    url "https://github.com/google/or-tools/commit/e0a4dcf5a082e7f90b73708fc7ff4a5e4760ed85.patch?full_index=1"
    sha256 "db8c40e25f68ea052dc74fc0ed163c1354667059632c8173ff42dc0c6a1f9bad"
  end

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
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.14)
      project(test LANGUAGES CXX)
      find_package(ortools CONFIG REQUIRED)
      add_executable(simple_lp_program #{pkgshare}/simple_lp_program.cc)
      target_compile_features(simple_lp_program PUBLIC cxx_std_17)
      target_link_libraries(simple_lp_program PRIVATE ortools::ortools)
    EOS
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
                    *shell_output("pkg-config --cflags --libs absl_log absl_raw_hash_set").chomp.split,
                    "-o", "simple_sat_program"
    system "./simple_sat_program"
  end
end
