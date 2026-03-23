class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/refs/tags/v9.15.tar.gz"
  sha256 "6395a00a97ff30af878ee8d7fd5ad0ab1c7844f7219182c6d71acbee1b5f3026"
  license "Apache-2.0"
  revision 5
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_tahoe:   "3ca962bc3a1acbed540baf02e7bee4eedab22f59850ceb63cec682adddc05a08"
    sha256               arm64_sequoia: "2f7669f46098357011ee1421f1e2c53a4787969c18821dd3ab4f752fc11befc6"
    sha256               arm64_sonoma:  "556730c92dc6d6bf00a09b03b46e9b9175bc41b16c3f0916a93e4675585d7233"
    sha256 cellar: :any, sonoma:        "4be0273cab3072696df85ff60af3e7c9c790f48232b16ae2046a32c631c0e1c6"
    sha256               arm64_linux:   "0f158b07eaa4f85805de04e14d01c9ec2439506a26d7ea3f916fe1572038ab59"
    sha256               x86_64_linux:  "812ba4e133a5259b4410e408e07c14f3f464649dca3f1adbf44add7d4907f000"
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

  on_macos do
    depends_on "cgl"
    depends_on "gmp"
    depends_on "mpfr"
    depends_on "openblas"
    depends_on "osi"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[
      -DUSE_HIGHS=ON
      -DBUILD_DEPS=OFF
      -DBUILD_SAMPLES=OFF
      -DBUILD_EXAMPLES=OFF
      -DUSE_SCIP=ON
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
