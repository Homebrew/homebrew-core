class Mlx < Formula
  desc "Array framework for Apple silicon"
  homepage "https://github.com/ml-explore/mlx"
  url "https://github.com/ml-explore/mlx/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "a5226ef3ab3fad06631d0ac9e980286df9863f8267fc38193f815a514cec253b"
  license "MIT"
  head "https://github.com/ml-explore/mlx.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:  "4cbb6a90d9db778b149ea384e6838bc890268682815a878e40336988361936bd"
    sha256 cellar: :any, arm64_ventura: "112e90dd579d21d71de21696a275f75301e46ef697eaff19f9c04a33457d910f"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on xcode: ["14.3", :build]
  depends_on arch: :arm64
  depends_on :macos
  depends_on "python@3.12"

  # Update to GIT_TAG at https://github.com/ml-explore/mlx/blob/v#{version}/mlx/io/CMakeLists.txt#L21
  resource "gguflib" do
    url "https://github.com/antirez/gguf-tools/archive/af7d88d808a7608a33723fba067036202910acb3.tar.gz"
    sha256 "1ee2dde74a3f9506af9ad61d7638a5e87b5e891b5e36a5dd3d5f412a8ce8dd03"
  end

  def python3
    "python3.12"
  end

  def install
    ENV.append_to_cflags "-I#{Formula["nlohmann-json"].opt_include}/nlohmann"
    (buildpath/"gguflib").install resource("gguflib")
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DFETCHCONTENT_SOURCE_DIR_GGUFLIB=#{buildpath}/gguflib
      -DMLX_BUILD_BENCHMARKS=OFF
      -DMLX_BUILD_EXAMPLES=OFF
      -DMLX_BUILD_METAL=OFF
      -DMLX_BUILD_PYTHON_BINDINGS=OFF
      -DMLX_BUILD_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    ENV[build.head? ? "DEV_RELEASE" : "PYPI_RELEASE"] = "1"
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "#{MacOS.version.major}.#{MacOS.version.minor.to_i}" if OS.mac?
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>

      #include <mlx/mlx.h>

      int main() {
        mlx::core::array x({1.0f, 2.0f, 3.0f, 4.0f}, {2, 2});
        mlx::core::array y = mlx::core::ones({2, 2});
        mlx::core::array z = mlx::core::add(x, y);
        mlx::core::eval(z);
        assert(z.dtype() == mlx::core::float32);
        assert(z.shape(0) == 2);
        assert(z.shape(1) == 2);
        assert(z.data<float>()[0] == 2.0f);
        assert(z.data<float>()[1] == 3.0f);
        assert(z.data<float>()[2] == 4.0f);
        assert(z.data<float>()[3] == 5.0f);
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17",
                    "-I#{include}", "-L#{lib}", "-lmlx",
                    "-o", "test"
    system "./test"

    (testpath/"test.py").write <<~EOS
      import mlx.core as mx
      x = mx.array(0.0)
      assert mx.cos(x) == 1.0
    EOS
    system python3, "test.py"
  end
end
