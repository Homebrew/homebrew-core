class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.16.0",
      revision: "e7a0495a874251e9747b2ce0683e0580282c54df"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "88f39807aa56ad40a61c0f8b216797554c51c9b393aa87bdd8c0b57fed435a73"
    sha256 cellar: :any,                 arm64_ventura:  "3534474544df8e8e6d10f340d341d81f83ed8b492982a669c0516a73e7fd4137"
    sha256 cellar: :any,                 arm64_monterey: "f9d45e3f7763567b953d358e8d3a24c9c82bdb9f06d09310ceb23dc9f8eab37c"
    sha256 cellar: :any,                 arm64_big_sur:  "6093903661103fa77352b07e9a6932989695d2298e2ef488caab3d1c74194b7e"
    sha256 cellar: :any,                 sonoma:         "2f5374af8403eb2a284601e5e571f09acfae49c433d4ffbf5fda3f03843152c6"
    sha256 cellar: :any,                 ventura:        "66d48c55a268609aa8701bda90cfa74f77226cce38f385c1739682c16af442b2"
    sha256 cellar: :any,                 monterey:       "661fc8fa556feacaf74bc5bf80a4b25949e35401042722eb9652a66c9c4732d0"
    sha256 cellar: :any,                 big_sur:        "f3a34bf25e11b8bec74a90d50792b40bebca0e93c90ae951bb44cdc0a257b575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3da7872f5719a30e713f6bf9cda8be8fca997f9b11d17bf7b35e90aac9c88edf"
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
