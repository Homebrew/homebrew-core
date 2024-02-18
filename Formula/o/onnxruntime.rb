class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.17.0",
      revision: "5f0b62cde54f59bdeac7978c9f9c12d0a4bc56db"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5314051b350fcb051cf1f475e0713f15450f5331bffba781bddabb1839d70697"
    sha256 cellar: :any,                 arm64_ventura:  "efd6e6abe16e74f6d3e7fa42bdda841a8c9b03683833634a06c504797a0df89a"
    sha256 cellar: :any,                 arm64_monterey: "7560e09909ca7cc7cee39dde7a84438f14fb7541cda9532027321bb977a51e6d"
    sha256 cellar: :any,                 sonoma:         "388acdd4cf3305908760c245a473d7fda80d23b8e2a3cf5a46f6865f229d7ca1"
    sha256 cellar: :any,                 ventura:        "63adf42fa0c6c85242e6b2db094c5c979544f5e252a8e0916c45cd04c9484eb0"
    sha256 cellar: :any,                 monterey:       "0962a756aff17fc9663cabd1985a23c307f05260c6b2acc8f02601abe076b03d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e552f720c40a3ff6166a3bd61a0b85836f79bb799aace5a1845a94eb18cadb89"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build

  fails_with gcc: "5" # GCC version < 7 is no longer supported

  def install
    cmake_args = %W[
      -Donnxruntime_RUN_ONNX_TESTS=OFF
      -Donnxruntime_GENERATE_TEST_REPORTS=OFF
      -DPYTHON_EXECUTABLE=#{which("python3.12")}
      -Donnxruntime_BUILD_SHARED_LIB=ON
      -Donnxruntime_BUILD_UNIT_TESTS=OFF
    ]

    system "cmake", "-S", "cmake", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <onnxruntime/onnxruntime_c_api.h>
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
