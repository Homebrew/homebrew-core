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
    sha256 cellar: :any,                 arm64_monterey: "1df38efbb3dabf25c4a8a66f0703576a9bd68030a33956cdea6f75701b84f9f0"
    sha256 cellar: :any,                 arm64_big_sur:  "b201b295f91bb36ea1ddd9a1fc369698466e790d2db462c74adf07cb5a7bd764"
    sha256 cellar: :any,                 monterey:       "8dcd8c225b6d6947c9fcf6417df6372b975f125237a5fc55496260c78abbc3a9"
    sha256 cellar: :any,                 big_sur:        "9df210ba239c623f6c0270db7c3e75089007422156be6c35867c37f060ede8f7"
    sha256 cellar: :any,                 catalina:       "ff4acf5025be335fbb577682f2ba438f749a64d12b6f7167a11c1aff29235dcc"
    sha256 cellar: :any,                 mojave:         "be2ce9d531cdc938a4587126364fa4fd7b237bc50d183d9aa3359969913e7b77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "469682bee07c34a201802ba90f228893035f8f16d58ad3a7d9a58f06d4a64427"
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
