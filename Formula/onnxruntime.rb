class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.7.1",
      revision: "711a31e2ea7f9d7512d29f26702476102bda4ca4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e2844199bfcfcae12e9d15da1559d87bf0d6945dd302e23e16b646aef451f869"
    sha256 cellar: :any, big_sur:       "75f2c88ccb0c65bcdf6d5441e53c05d389a266ed3f8894bf2b6f4dcdad3bf8dc"
    sha256 cellar: :any, catalina:      "2eb0fe993ca4fbf621f51ecdb7e0d502fe369de12a1f9863c3eef3b950c9814d"
    sha256 cellar: :any, mojave:        "7ef9a5fcf95576b1d62b08ed09ec4d15d567ea3a5799333c36889fcc5e29194a"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  def install
    cmake_args = %W[
      -Donnxruntime_RUN_ONNX_TESTS=OFF
      -Donnxruntime_GENERATE_TEST_REPORTS=OFF
      -DPYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3
      -Donnxruntime_BUILD_SHARED_LIB=ON
      -Donnxruntime_BUILD_UNIT_TESTS=OFF
    ]

    mkdir "build" do
      system "cmake", "../cmake", *std_cmake_args, *cmake_args
      system "make", "install"
    end
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
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lonnxruntime",
           testpath/"test.c", "-o", testpath/"test"
    assert_equal version, shell_output("./test").strip
  end
end
