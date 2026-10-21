class MlxC < Formula
  desc "C API for MLX"
  homepage "https://ml-explore.github.io/mlx-c/build/html/index.html"
  url "https://github.com/ml-explore/mlx-c/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "ee726bb38e191bb3c516a6bae47dc8abad9e5f273873385839019ce46bfceab5"
  license "MIT"
  revision 1
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bc630d594ae8232913f188c87a8d340469a97478000ac46045da4c893510feea"
    sha256 cellar: :any, arm64_tahoe:       "a11108e16e96648fc6c39b1b352f5ea3aed44b945e95aaf39687f5b12d1daf41"
    sha256 cellar: :any, arm64_sequoia:     "7288ed180ed242a6a946b27c0e9ee5adaf20d1bdffed03504dcc937e088dfe74"
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

  # TODO: Remove when a release includes MLX 0.32.3 compatibility.
  # Fix gather_qmm compatibility, upstream PR ref, https://github.com/ml-explore/mlx-c/pull/137
  patch do
    url "https://github.com/ml-explore/mlx-c/commit/cfc471f4200f608936bfe68d029b2252075642e1.patch?full_index=1"
    sha256 "3cc6a5c3fb091b7cae7e9da19f72d422122404f61a56c9ce96c2c904ae06a586"
    type :unofficial
    resolves "https://github.com/ml-explore/mlx-c/issues/136"
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
