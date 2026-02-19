class MlxC < Formula
  desc "C API for MLX"
  homepage "https://ml-explore.github.io/mlx-c"
  url "https://github.com/ml-explore/mlx-c/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "dcfc404d7004e6da70170c669dbc920913cb25a59c9f7dac781caf92e524cc86"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9c01f1a7b9ad2b7ce2a6017c29b6468ba076b5bd86c71ad857d622fad3b967d0"
    sha256 cellar: :any, arm64_sequoia: "7b60942bf95ad387777939244dfc981878461d9c81bca995ad285c0b7c1b7d23"
    sha256 cellar: :any, arm64_sonoma:  "8b862ecfc2b03ec842c2e18b97a1dfb8b53374f7163180c54704fe92d603fafc"
  end

  depends_on "cmake" => :build
  depends_on arch: :arm64
  depends_on :macos
  depends_on "mlx"

  def install
    args = %w[
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
