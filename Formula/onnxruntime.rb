class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.8.2",
      revision: "430e80e7b6e5e6222b2d90ca5e43609d62082722"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "63d1a2319fcd4589562aeed0bad0c5821067c71e0ef371b58428bfc0f3dcd56f"
    sha256 cellar: :any,                 big_sur:       "b6a178b99a6594aba434cb7071c476d9679824bc514094d5e1851ae1bda815ed"
    sha256 cellar: :any,                 catalina:      "345bce23cef3f847783d259e352b7eff4838bf7a2231c6c6f2c615b87683fb8d"
    sha256 cellar: :any,                 mojave:        "bdf468725041bdeabab3909fed1fa1153cbea6c78e9e334eb0db854f9727465a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6091d9b3c0edb995f180156ca4fbb78601372583a417cf5d4cfb0c315b20cb3b"
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
    system ENV.cc, "-I#{include}", testpath/"test.c",
           "-L#{lib}", "-lonnxruntime", "-o", testpath/"test"
    assert_equal version, shell_output("./test").strip
  end
end
