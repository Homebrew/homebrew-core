class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.12.0",
      revision: "f4663641764ccc3e93a617ab63ae4ff1badc2ee1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a4727749a8deaa24e17cb576dc09b1f4a960cc95e17501d96f1e84fead0fe599"
    sha256 cellar: :any,                 arm64_big_sur:  "b4f526aa9d762e351435468c96b9fc7b42225a14c93520a3b1640da578427862"
    sha256 cellar: :any,                 monterey:       "4eac4ffe77bd4caa22c6ad4b919770d4efaa709819857c6313d5e06a9ec96514"
    sha256 cellar: :any,                 big_sur:        "9c7ae774b0c6cfd5de1b027d51779dd9420ca67e8ac344625c7574ff720690a9"
    sha256 cellar: :any,                 catalina:       "85fb5f606e197580ad5b107a6b8e27bd961d016537a50ba359f1a082a728c861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d14eda7d648a7bdc74c9be42223dda2f7defede2992b165badc734718f93a698"
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
