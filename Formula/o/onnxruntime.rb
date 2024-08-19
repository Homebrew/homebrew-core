class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.17.1",
      revision: "8f5c79cb63f09ef1302e85081093a3fe4da1bc7d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d97103bb5f94fab8a364c031879f186079ec34ff3e3034d9f9a9d941cfa7ba99"
    sha256 cellar: :any,                 arm64_ventura:  "7515067567fb810bd6a49b9b221458cd6a7c377e220279f199151808a9e1bfc1"
    sha256 cellar: :any,                 arm64_monterey: "b9963245e88af5ef863bcf0e8d28c078c312ab31d330eae4e69c243837281ec4"
    sha256 cellar: :any,                 sonoma:         "31bd37397424abc33c1981dede657ba0f1b7209262c70854b774841857809b88"
    sha256 cellar: :any,                 ventura:        "eab070cc7924e3b5d38277f24b3313c4b181e6fd9a7f4f8e0f539a057ff1f544"
    sha256 cellar: :any,                 monterey:       "aa8b359507d4b024ce46baadf0c75772fe1ba6ffb3e43551cf6e3d6b7a487fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dde778dd1564940af7b2116cba7d4c8b45b4d6e335c78620cf97b1e1e6a688b1"
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
