class MlxC < Formula
  desc "C API for MLX"
  homepage "https://ml-explore.github.io/mlx-c/build/html/index.html"
  url "https://github.com/ml-explore/mlx-c/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "ea6251d37968ec3a7975982d2eb38b008ee2a6bfa75bee1132cae178a39765e2"
  license "MIT"
  compatibility_version 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e7c706961036e792d9a693388cbc8bdad39c8a19c776b061b4c65ac2a88442d4"
    sha256 cellar: :any, arm64_tahoe:       "c81ab3e3177acc5cbdcc27e2c7651afeaeec28509231f44bfedb985420868606"
    sha256 cellar: :any, arm64_sequoia:     "ffcb6877cde6ed171eed91b79cda3ec855849c3ce434602b811c419fca6715d4"
  end

  depends_on "cmake" => :build
  depends_on arch: :arm64
  depends_on :macos
  depends_on "mlx"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  def install
    args = %w[
      -DCMAKE_CXX_STANDARD=20
      -DBUILD_SHARED_LIBS=ON
      -DMLX_C_BUILD_EXAMPLES=OFF
      -DMLX_C_USE_SYSTEM_MLX=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/example.c"
  end

  test do
    system ENV.cc, pkgshare/"example.c", "-o", "test", "-L#{lib}", "-lmlxc"
    assert_match "array([0, 0.5, 1, 1.5, 2, 2.5], dtype=float32)", shell_output("./test")
  end
end
