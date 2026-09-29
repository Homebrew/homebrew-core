class MlxC < Formula
  desc "C API for MLX"
  homepage "https://ml-explore.github.io/mlx-c/build/html/index.html"
  url "https://github.com/ml-explore/mlx-c/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "ee726bb38e191bb3c516a6bae47dc8abad9e5f273873385839019ce46bfceab5"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "17af7d8b5c558041f540738c34197c2723fd70dbcfc5fea8f238e1851a21d6b4"
    sha256 cellar: :any, arm64_tahoe:       "856317588f1e0866678da73ee50ac191bc6aba472096b4bb021bafc582d1ee58"
    sha256 cellar: :any, arm64_sequoia:     "604afaea83fb354c7b487f975275c0fa30760da9a4e3f27cbeba93e70331ffc5"
    sha256 cellar: :any, arm64_sonoma:      "cb36d918641b9fb2e8e26e70eb2676ffc35b3f46801b0639409d1212a90eecdd"
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
