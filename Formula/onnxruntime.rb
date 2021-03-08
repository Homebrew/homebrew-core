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
    sha256 cellar: :any, arm64_big_sur: "66a6e15cfb53c88797492f936e07dacbb5236a4ced576d05b4e6b80b784dadaa"
    sha256 cellar: :any, big_sur:       "156c92b0dbe1a9bd525f52f953930a7a38aeaf43a7bb8c68f0f6463922918586"
    sha256 cellar: :any, catalina:      "fea226f84a61d74cfc5787056cbac1a2371450ba8ddff73e81d8b7a15d50a563"
    sha256 cellar: :any, mojave:        "6b8d1a27a5303e58e6a81bd5efd997725784676d4fbc773fa8a764a3d23564a9"
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
