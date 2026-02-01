class MlxC < Formula
  desc "C API for MLX"
  homepage "https://ml-explore.github.io/mlx-c"
  url "https://github.com/ml-explore/mlx-c/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "e22b51b810b9c3bdce8c0df0d6112ca8e8a49ce0ea78b504e1bdbb59d731f5d8"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "252a76effb17e213664f0cddb0b0c28496fa1bdad146ef806416ada91f84e584"
    sha256 cellar: :any, arm64_sequoia: "793a81852a0b4898941e7deb9613aa200025faf65550c29d3d2dd7cd130525aa"
    sha256 cellar: :any, arm64_sonoma:  "06a4da8e44d45deb666ed5a92f32b551202b114c485c54e1817e327ecffb7601"
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
