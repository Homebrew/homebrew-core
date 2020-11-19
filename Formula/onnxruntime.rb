class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
    tag:      "v1.5.3",
    revision: "7bcf796a0d3208b0c193d1758708495b09281e0a"
  license "MIT"

  livecheck do
    url "https://github.com/microsoft/onnxruntime/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "be468c772ca674e7c898910f52228a32434e3c6cb0662fe7f4604a9fb46e7f0d" => :big_sur
    sha256 "8523ac42679c8d4ab9b7224468020781a2654abad851d7e95a3d570cd29456c2" => :catalina
    sha256 "c9f06b98661dfba06e3bdebc1743274f1a77c0af78f3f7b5290c01f900e5ee2d" => :mojave
    sha256 "21055d5a282b4c9501d3623a6d3b5dae04954e6cf925fbdc93d4d9723d634e7d" => :high_sierra
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
      -DCMAKE_BUILD_TYPE=Release
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
