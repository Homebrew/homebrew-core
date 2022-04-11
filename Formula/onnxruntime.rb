class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.11.0",
      revision: "b713855a980056d89a1e550ad81dc3c19573d7a0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1cdcb9598a23ad0be8a1776199d73e733365ca978164176d0fa90bb5b063edfb"
    sha256 cellar: :any,                 arm64_big_sur:  "f601a703b06780d06913558687e96da6d78e21223511dd8be136e8b18905c552"
    sha256 cellar: :any,                 monterey:       "cb84a2af1cb8ec21bdfae68b9092ae7143289c92f4b3f44141715ca3401902e7"
    sha256 cellar: :any,                 big_sur:        "17c628ab8e1dd66589f77ff8636b029d898a436cfcfe0adb9a97341468227652"
    sha256 cellar: :any,                 catalina:       "4f1a2221ae2b1a476f227c4a606e54224dfa6c7c88f5efa7de7594ab43901d58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "534b624d5f270e3884828d45359155587dc0bd2154ec0ed9c767b23f9031b292"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # GCC version < 7 is no longer supported

  def install
    cmake_args = %W[
      -Donnxruntime_RUN_ONNX_TESTS=OFF
      -Donnxruntime_GENERATE_TEST_REPORTS=OFF
      -DPYTHON_EXECUTABLE=#{Formula["python@3.10"].opt_bin}/python3
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
