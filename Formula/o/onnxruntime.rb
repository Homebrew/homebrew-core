class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.16.1",
      revision: "2a1fd2586ff9ea7b2af94a7d4b1b3c124f5f3cda"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "a3b73b535a1df178034f0b1289a1e8c610e72b39fd5b865819435ef081c1819b"
    sha256 cellar: :any,                 arm64_ventura:  "8d1d0ab70ab5c0f74909510fd58756f424482db84d3d0646098ac49b3ffef243"
    sha256 cellar: :any,                 arm64_monterey: "1fad4bc28a6395f17a069dca8ff4812c10fba8f2747b1ac2c9ac01a4667bcd26"
    sha256 cellar: :any,                 sonoma:         "9ef4e9b86b447551c6010604bfbda69a71b69d0ca890238c47997b09ea7522c4"
    sha256 cellar: :any,                 ventura:        "503e31e73051fc0d4545e1a53c64b61b456f238e0b5dc4dc778e9299c60a5db3"
    sha256 cellar: :any,                 monterey:       "d2ae23f902f577b4b9ef84cc0044cad3626b8d0ac1facac03f006179093bbd5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9455ab44856e2a0fc27f8ebff5eca39877c66453ed448db6d903a6589ce0b16a"
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
