class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.7.2",
      revision: "5bc92dff16b0ddd5063b717fb8522ca2ad023cb0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "30a3ce923c1fa618be19422dc681c58cc09cb6a6f68bd1975c2aecf79193e968"
    sha256 cellar: :any, big_sur:       "2c3ac3e4dedae160f330c2bc9e20935e87782beca92dff0cb45fc4e3cea030f0"
    sha256 cellar: :any, catalina:      "ee9e6022aa52a6b9b17c4d8369843fe14cc49a2623af62c66862f814d05e12d9"
    sha256 cellar: :any, mojave:        "1065d75cd9a1aa4c05a7475f65cf67e3f71ed3e3494234f91e7e375f2bb60972"
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
