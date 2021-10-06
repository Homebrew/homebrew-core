class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.9.1",
      revision: "2a96b73a1afa9aaafb510749627e267c4e8dee63"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9151d3423bb6c119d0034bbd5d451d8de72edbce0daac7b9fa3efcea4a60f8a6"
    sha256 cellar: :any,                 big_sur:       "b6eab00990177c702f90354cc818a066281c874995ded531835c29fff903bde0"
    sha256 cellar: :any,                 catalina:      "a5a88e4844530b2b8cabd0320bdd1bc63763901fed5aeb425645019cedddff16"
    sha256 cellar: :any,                 mojave:        "81dac3a785d33e76b2969b091207180b585a1ddd055577b5695920702cc4af6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9136e98a1585ef11161013b12eabffdc63fbfdac2c76cb8f24aff8f9862a5ff4"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  on_linux do
    depends_on "gcc" => :build
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
