class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/refs/tags/v9.15.tar.gz"
  sha256 "6395a00a97ff30af878ee8d7fd5ad0ab1c7844f7219182c6d71acbee1b5f3026"
  license "Apache-2.0"
  revision 17
  head "https://github.com/google/or-tools.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "6917a75e21040f4b62f5ab07f01b2caa1ae0c7557eb3632eb1fea5daca25b1d6"
    sha256 cellar: :any, arm64_golden_gate: "9e2fd9809b02c9136e59eab7d1a7723428de35f09885c0d894a27e182a4f54d2"
    sha256 cellar: :any, arm64_tahoe:       "73f26f1de6cd97c61a08cadbf571fb51cb5edfc564b86e7d719248a921e61b00"
    sha256 cellar: :any, arm64_sequoia:     "0e2dadf8f2b3761287635db29dc440f2aa876f0779dc7b05d3f2aa22e7d7335b"
    sha256               arm64_linux:       "d2080973dacd80ffed5c7a86ae50db81d0d05bf7395320417c40f2018686e321"
    sha256               x86_64_linux:      "a92d99b1a4f6c43818cd56b49fe443767e5bc96a08f7bdddded8418d96738fe3"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => [:build, :test]
  depends_on "abseil"
  depends_on "cbc"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "eigen" => :no_linkage
  depends_on "highs"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "scip"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Backport abseil 20260526.0 build fix (absl::SourceLocation ODR conflict).
  patch do
    url "https://github.com/google/or-tools/commit/a8c25e646e7b645c462db4be7c62e544b252e8fa.patch?full_index=1"
    sha256 "1a20aa39165cd978c1274932ab19225540338a228e756be5b28f1b29006b03e3"
    type :backport
    resolves "https://github.com/google/or-tools/pull/5180"
  end

  def install
    args = %w[
      -DUSE_HIGHS=ON
      -DBUILD_DEPS=OFF
      -DBUILD_SAMPLES=OFF
      -DBUILD_EXAMPLES=OFF
      -DUSE_SCIP=ON
    ]
    args += %w[EXE SHARED].map { |type| "-DCMAKE_#{type}_LINKER_FLAGS=-Wl,-dead_strip_dylibs" } if OS.mac?

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
                    "-DOR_PROTO_DLL=", "-DPROTOBUF_USE_DLLS",
                    *shell_output("pkg-config --cflags --libs absl_check absl_log").chomp.split,
                    "-o", "simple_routing_program"
    system "./simple_routing_program"

    # Sat Solver
    absl_libs = %w[
      absl_check
      absl_log_initialize
      absl_flags
      absl_flags_parse
    ]
    system ENV.cxx, "-std=c++17", pkgshare/"simple_sat_program.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    "-DOR_PROTO_DLL=", "-DPROTOBUF_USE_DLLS",
                    *shell_output("pkg-config --cflags --libs #{absl_libs.join(" ")}").chomp.split,
                    "-o", "simple_sat_program"
    system "./simple_sat_program"

    # Highs backend
    (testpath/"highs_test.cc").write <<~CPP
      #include "ortools/linear_solver/linear_solver.h"
      using operations_research::MPSolver;
      int main() {
        if (!MPSolver::SupportsProblemType(MPSolver::HIGHS_LINEAR_PROGRAMMING)) return 1;
        MPSolver solver("t", MPSolver::HIGHS_LINEAR_PROGRAMMING);
        auto* x = solver.MakeNumVar(0.0, 1.0, "x");
        auto* obj = solver.MutableObjective();
        obj->SetCoefficient(x, 1.0);
        obj->SetMaximization();
        if (solver.Solve() != MPSolver::OPTIMAL) return 2;
        return x->solution_value() > 0.99 ? 0 : 3;
      }
    CPP
    system ENV.cxx, "-std=c++17", "highs_test.cc",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    "-DOR_PROTO_DLL=", "-DPROTOBUF_USE_DLLS",
                    *shell_output("pkg-config --cflags --libs #{absl_libs.join(" ")}").chomp.split,
                    "-o", "highs_test"
    system "./highs_test"
  end
end
