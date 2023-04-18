class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.14.1",
      revision: "c57cf374b67f72575546d7b4c69a1af4972e2b54"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "59fa13559228408224899e11052207b905a42117ea344044cca443f83f786dc6"
    sha256 cellar: :any,                 arm64_monterey: "68722726524b8c0fa36ffdc7bb580a727727e3ccad0c68b8bf7a0f24168029ba"
    sha256 cellar: :any,                 arm64_big_sur:  "2db795684913f49fa2ed5644b9d0942b422e16dea469eda38c65c558eb2b6f81"
    sha256 cellar: :any,                 ventura:        "9f941aa3dff793062720d49b38914481e7aa92dba09a70f6940c400c6c684710"
    sha256 cellar: :any,                 monterey:       "9a8c6ea07f884d275c37f965d4d1cd363014ccb77c3abcca9e870cb309a5b402"
    sha256 cellar: :any,                 big_sur:        "5391f619684d0d583e510cc472903047dc85780b91c65212c7dd685ce48498de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a6ab66baa78bbd14374d024c86972dacfea886703d8d96ad8c9297cb792e250"
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
