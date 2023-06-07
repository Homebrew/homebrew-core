class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.15.0",
      revision: "638146b79ea52598ece514704d3f592c10fab2f1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "819ccedab4fea6da9e2c135c5259ecb01295f695269c2813ae1d1bea3e5f6141"
    sha256 cellar: :any,                 arm64_monterey: "05dd3c7d8e9aac74ccdbc0a35da7ebd331ab5a662d08738654ceb4ef20c9dce2"
    sha256 cellar: :any,                 arm64_big_sur:  "6c9897d7319a36f90c1cd540416cb39fc1a764f35239a763c9184aef78678740"
    sha256 cellar: :any,                 ventura:        "fcbe235bbf2fe7c2a7860f217dde6cf34221454a71b7871bd3be6d8f35a14d32"
    sha256 cellar: :any,                 monterey:       "7829d861a61fed94de73d4d97c12629f5fef4cbf25227e3717006528334e4600"
    sha256 cellar: :any,                 big_sur:        "80217b41dcc871dcaf82099c2f35165bc36940e40a30654c06a94fbff7065c62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d7d655ff1332e93fd9a3058f3c71a531122add5f21c98ce6254d4a78627a523"
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
