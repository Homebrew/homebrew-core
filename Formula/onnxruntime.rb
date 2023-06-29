class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.15.1",
      revision: "baeece44ba075009c6bfe95891a8c1b3d4571cb3"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fa1614a946d6b74b70975191cc6d737371bda484702a6647b9c7653aba36293f"
    sha256 cellar: :any,                 arm64_monterey: "0ede3332d4a1371429a8ebfdb91ec5783f7853fa963311cd5e8d9439d8a0c9f8"
    sha256 cellar: :any,                 arm64_big_sur:  "c01b8c3bc163fd3848fda6b7b64d62117a614b1d6a0065e59fa72a0844375fe5"
    sha256 cellar: :any,                 ventura:        "6bf6dcff3ce48adf469a9862c8c9287b749312c1974a67cf80c261c908537824"
    sha256 cellar: :any,                 monterey:       "f32d282661b950e8012b8fc8ca3785cf22f51f9242ce3e3518306caf5c9ce3ec"
    sha256 cellar: :any,                 big_sur:        "9372f3aff5069794712399f9af4fa170f1c96e7d8b33869baa860967e18b1533"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9b3e169149c0eff76f9ef8a9400f7ca6f585049f75669cc9c8b805818da44ab"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  fails_with gcc: "5" # GCC version < 7 is no longer supported

  def install
    cmake_args = %W[
      -Donnxruntime_RUN_ONNX_TESTS=OFF
      -Donnxruntime_GENERATE_TEST_REPORTS=OFF
      -DPYTHON_EXECUTABLE=#{which("python3.11")}
      -Donnxruntime_BUILD_SHARED_LIB=ON
      -Donnxruntime_BUILD_UNIT_TESTS=OFF
    ]

    system "cmake", "-S", "cmake", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <onnxruntime/core/session/onnxruntime_c_api.h>
      #include <stdio.h>
      int main()
      {
        printf("%s\\n", OrtGetApiBase()->GetVersionString());
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", testpath/"test.c",
           "-L#{lib}", "-lonnxruntime", "-o", testpath/"test"
    assert_equal version, shell_output("./test").strip
  end
end
