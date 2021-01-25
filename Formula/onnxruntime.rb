class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.6.0",
      revision: "718ca7f92085bef4b19b1acc71c1e1f3daccde94"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "d7883b8f973ba719e20283677ee50d42f64157217477adc22d54c6fbf0501a91" => :big_sur
    sha256 "9f3e990083162dcee2d6162833ad33093565629ef5a6be16207c130f04424a03" => :arm64_big_sur
    sha256 "5482c3326db23684cae036c35d311d21e9828fa7324646a3eb29cafd1390cf08" => :catalina
    sha256 "61a7101bc2a72943b88fd82aab691ad5dabb58798ac55807b6c8b9c88dfd4c94" => :mojave
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
