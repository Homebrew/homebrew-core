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
    sha256 cellar: :any,                 arm64_monterey: "cdac93f2044a8ed03a0bba92156f3ea083086245d7e7e52431c47605f3d06683"
    sha256 cellar: :any,                 arm64_big_sur:  "bf3175a3e5eca7000a64ce5c3bbbd20f19642886d75a55988a70163a7f03217a"
    sha256 cellar: :any,                 monterey:       "e8ee54aedea8f788c66470e4d32a4cf725be72efe1451f83b1920da58596a3c2"
    sha256 cellar: :any,                 big_sur:        "9401fd0650bc89ae510d639183a0ac0053dc0031aec64ea05105408dbdadb7e9"
    sha256 cellar: :any,                 catalina:       "d91fe2217bf5faaa6cdb16ec7f0a58e7eb96d147018dc5f1341c0ef87f1dd7d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "123549ac2b7f9629527152d9d2711bd1e5ba09274a6fe77dab8acda705d776cd"
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
