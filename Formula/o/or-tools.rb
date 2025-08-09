class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/refs/tags/v9.14.tar.gz"
  sha256 "9019facf316b54ee72bb58827efc875df4cfbb328fbf2b367615bf2226dd94ca"
  license "Apache-2.0"
  revision 2
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "7ce8536119bdc17013e8e1af390d35089c90a82c00a2e2b7f060664d8a6ebcc6"
    sha256 cellar: :any,                 arm64_sonoma:  "cf67629211b9483eda40865ef3d73b22931237fc6ad33c6add8d1860d06ffaee"
    sha256 cellar: :any,                 arm64_ventura: "8007ad563566751f66d77f871b4ecc81bd66b51d331d5416f560fa4e88d57ace"
    sha256 cellar: :any,                 sonoma:        "e8e5cef74403cbdbabdb6ffb46bdd4a02031af1d26b6b3be9672d2a9efd4faf6"
    sha256 cellar: :any,                 ventura:       "abb9cc2a587012012bc89bf9c892cfe5e3c894c35efc20277870d985feeb0c66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a57fca0beeca2fc09d465e54f4ca599d5fdc313b3371232e5db3d5bbdb43bf43"
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
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    # Fix for wrong target name for `libscip`.
    # Reported at https://github.com/google/or-tools/issues/4750.
    libscip_files = %w[
      cmake/check_deps.cmake
      cmake/docs/cmake.dot
      cmake/docs/cmake.svg
      cmake/docs/deps.dot
      cmake/docs/deps.svg
      cmake/java.cmake
      cmake/ortoolsConfig.cmake.in
      cmake/python.cmake
      cmake/system_deps.cmake
      ortools/dotnet/Google.OrTools.runtime.csproj.in
      ortools/gscip/CMakeLists.txt
      ortools/linear_solver/CMakeLists.txt
      ortools/linear_solver/proto_solver/CMakeLists.txt
      ortools/linear_solver/wrappers/CMakeLists.txt
      ortools/math_opt/io/CMakeLists.txt
      ortools/math_opt/solvers/CMakeLists.txt
    ]
    inreplace libscip_files, "SCIP::libscip", "libscip"

    # FIXME: Upstream enabled Highs support in their binary distribution, but our build fails with it.
    args = %w[
      -DUSE_HIGHS=OFF
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
  end
end
