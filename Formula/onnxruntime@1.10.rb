class OnnxruntimeAT110 < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.10.0",
      revision: "0d9030e79888d1d5828730b254fedc53c7b640c1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # GCC version < 7 is no longer supported

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
    system ENV.cc, "-I#{include}", testpath/"test.c",
           "-L#{lib}", "-lonnxruntime", "-o", testpath/"test"
    assert_equal version, shell_output("./test").strip
  end
end
