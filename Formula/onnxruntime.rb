class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.12.1",
      revision: "70481649e3c2dba0f0e1728d15a00e440084a217"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "0dca715030695599f96a784b2e7cd56bb189c99cbe83f7d7fa9c1caaebc63072"
    sha256 cellar: :any,                 arm64_big_sur:  "e5a5db78d8830c8bbe53cefd70ff5b988a74b3ae1be76190587459d8e749309b"
    sha256 cellar: :any,                 monterey:       "950ab910aaf6cfd3a12ca739f989c03620a864d4a6f2ac2dc43baeeed7a5da24"
    sha256 cellar: :any,                 big_sur:        "4c3abe9c82c7476defcb08471dce2260e32d1ecbed5c12bada7d81be07ca19aa"
    sha256 cellar: :any,                 catalina:       "8d18e8779b2d180a50b79e0558aaedbaadb8a0cb2286c4968cf6318ed8f4fe83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fcb18d068f4de34c67fa43666d77a5e5917d12d5c0e3a01043e6641c3387504"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  fails_with gcc: "5" # GCC version < 7 is no longer supported

  def install
    cmake_args = %W[
      -Donnxruntime_RUN_ONNX_TESTS=OFF
      -Donnxruntime_GENERATE_TEST_REPORTS=OFF
      -DPYTHON_EXECUTABLE=#{which("python3.10")}
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
