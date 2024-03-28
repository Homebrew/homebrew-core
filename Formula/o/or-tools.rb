class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  # TODO: Replace `protobuf` resource with `depends_on "protobuf"` when Protobuf 26+ is supported
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
    sha256 cellar: :any,                 arm64_sonoma:   "c5cc35b76492c953a57256eb115c69905e5dc5d5ca2f39b1dc0ed9786b2a33ea"
    sha256 cellar: :any,                 arm64_ventura:  "bbf4cf76136e1a9415680fe33a1a9dadcf86bb9dacb028d0d014854e3152676b"
    sha256 cellar: :any,                 arm64_monterey: "fb24f811fa158a4f15ae4f69d88455e0b234584814a373e00eaea713eacf8b01"
    sha256 cellar: :any,                 sonoma:         "706a90a61821b37f56343fbdb3e8d4d5784c5bb0b53373db58a1d042f0c4f824"
    sha256 cellar: :any,                 ventura:        "38c59ae5cdad3ef902ecb7b7fa53ce8c0c581e831014415981f1958af044edde"
    sha256 cellar: :any,                 monterey:       "bf37faa106adb339dfa94c886011e32a2341b41dac4b4db3e636a80662e4f001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10a12171d09df1c69aa0ac061e0beb34f8a462e4366765bd01c4975b136de050"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkg-config" => [:build, :test]
  depends_on "protobuf" => :test # to check that correct Protobuf is found
  depends_on "abseil"
  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "eigen"
  depends_on "openblas"
  depends_on "osi"
  depends_on "re2"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  resource "protobuf" do
    url "https://github.com/protocolbuffers/protobuf/releases/download/v25.3/protobuf-25.3.tar.gz"
    sha256 "d19643d265b978383352b3143f04c0641eea75a75235c111cc01a1350173180e"
  end

  def install
    # TODO: Remove the following `protobuf` installation, the CMake modifications, and the
    # `-DCMAKE_PREFIX_PATH=#{libexec}` arg when switching back to `protobuf` formula dependency.
    resource("protobuf").stage do
      args = %w[
        -DBUILD_SHARED_LIBS=ON
        -Dprotobuf_BUILD_SHARED_LIBS=ON
        -Dprotobuf_BUILD_TESTS=OFF
        -Dprotobuf_ABSL_PROVIDER=package
        -Dprotobuf_JSONCPP_PROVIDER=package
      ]
      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    # Help `find_package(ortools)` and corresponding targets find libexec-installed Protobuf
    inreplace "cmake/ortoolsConfig.cmake.in",
              "find_dependency(Protobuf REQUIRED)",
              "find_dependency(Protobuf CONFIG REQUIRED PATHS \"#{libexec}\" NO_DEFAULT_PATH)"
    inreplace "cmake/cpp.cmake", <<~EOS, "\\0  \"#{libexec}/include\"\n"
      target_include_directories(${PROJECT_NAME} INTERFACE
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>
        $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}>
    EOS
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}/lib"

    args = %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
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
    cp pkgshare.children, testpath

    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.14)
      project(test LANGUAGES CXX)
      find_package(ortools CONFIG REQUIRED)

      add_executable(simple_lp_program simple_lp_program.cc)
      target_compile_features(simple_lp_program PUBLIC cxx_std_17)
      target_link_libraries(simple_lp_program PRIVATE ortools::ortools)

      add_executable(simple_routing_program simple_routing_program.cc)
      target_compile_features(simple_routing_program PUBLIC cxx_std_17)
      target_link_libraries(simple_routing_program PRIVATE ortools::ortools)
    EOS

    with_env(CPATH: nil) do
      system "cmake", "-S", ".", "-B", ".", *std_cmake_args
      system "cmake", "--build", "."
    end

    # Linear Solver & Glop Solver
    system "./simple_lp_program"

    # Routing Solver
    system "./simple_routing_program"

    # Sat Solver
    system ENV.cxx, "-std=c++17", "simple_sat_program.cc",
                    "-I#{libexec}/include",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    *shell_output("pkg-config --cflags --libs absl_log absl_raw_hash_set").chomp.split,
                    "-o", "simple_sat_program"
    system "./simple_sat_program"
  end
end
