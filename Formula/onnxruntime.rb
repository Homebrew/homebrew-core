class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.13.1",
      revision: "b353e0b41d588605958b03f9a223d10a2fbeb514"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "820848cee92dd69f5b063945901be4c3b68e57ba3789bd6386c82635c411c64f"
    sha256 cellar: :any,                 arm64_monterey: "bc8914ae115b17c564281c81e21ee0fed26ccc5884dbd4644c879e87315643b7"
    sha256 cellar: :any,                 arm64_big_sur:  "5618ef80c6f28b9ab4388699ecc434b9daf91c77864147a27718b7d97048a901"
    sha256 cellar: :any,                 ventura:        "37b36297a72347ff0238d514bc7673cb6cd00b41b3a9fe8fd6fce9b7d508ae6e"
    sha256 cellar: :any,                 monterey:       "1089f14d4be6c984c891a9718e9f0bbb01cdb41730aac67e529f397284aa8e24"
    sha256 cellar: :any,                 big_sur:        "5334140c6721a125b83bd3130cd8c0b86bd5050f59c15d2f842038bbf04e679f"
    sha256 cellar: :any,                 catalina:       "d18a5c72bc777468e6e53c5cd2700d6b03dc279e95c80e3d88d359ba59787112"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fda7083fd01d859c83f78d4b5e582aa76c9faf89e56022ef65d2b5dfeece882b"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  fails_with gcc: "5" # GCC version < 7 is no longer supported

  def install
    cmake_args = %W[
      -Donnxruntime_RUN_ONNX_TESTS=OFF
      -Donnxruntime_GENERATE_TEST_REPORTS=OFF
      -DPYTHON_EXECUTABLE=#{which("python3.10")}
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
