class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.8.0",
      revision: "d4106deeb65c21eed3ed40df149efefeb72fe9a4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "45a4521a6931f7dfb76d0f3bf6e297aff4e014d1f40d54fb4bc5bcd71d246ce6"
    sha256 cellar: :any, big_sur:       "5648048c5d41d3b093d74297379e7ceb4bd762d7103e1ccd9efb1addf687ee1d"
    sha256 cellar: :any, catalina:      "f1a8b759da014e3aff32c6c1412d6831ecb2d6dff100492379ddad0e5d8ec146"
    sha256 cellar: :any, mojave:        "c457425070ed99f7ebcdd0078f1025063d884ed4c8e19fad7c7f20ce8a532e8f"
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
