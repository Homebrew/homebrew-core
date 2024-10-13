class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/refs/tags/v9.11.tar.gz"
  sha256 "f6a0bd5b9f3058aa1a814b798db5d393c31ec9cbb6103486728997b49ab127bc"
  license "Apache-2.0"
  revision 1
  head "https://github.com/google/or-tools.git", branch: "stable"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d96a2474dcec3e479e493f9a2feea94fdba14d1142c3a03fd955a2ebe8ccabf0"
    sha256 cellar: :any,                 arm64_sonoma:  "b334335e402ba2def5df45083b409feee658658fb144f91125f12c82846327fb"
    sha256 cellar: :any,                 arm64_ventura: "944b2e33feaf16cbc65b85c389dc7c51b24c49cca9ff174a356cf7af617b7726"
    sha256 cellar: :any,                 sonoma:        "e9a11426f2c10f3f084bbcfcac027b9c888b7b73be0d7db45bf16f6ca7530d35"
    sha256 cellar: :any,                 ventura:       "bca479d83dbef1eef8370315db6e2258ab265fb23850a9404d5fd1c63b55b1b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "813619753bab47c09c9eadea6d600301d90699ad56cb490104650b4663266586"
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
  depends_on "scip"
  uses_from_macos "zlib"

  fails_with gcc: "5"

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
