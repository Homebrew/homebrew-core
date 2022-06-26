class Onnxruntime < Formula
  desc "Cross-platform, high performance scoring engine for ML models"
  homepage "https://github.com/microsoft/onnxruntime"
  url "https://github.com/microsoft/onnxruntime.git",
      tag:      "v1.11.1",
      revision: "366f4ebcb425b6a47c2b0decd3b39fa14eb9dbf6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "67395f4da47c0fe369eca4f1ddefcd3bc1ac80602e5028ae831d3ea45a501cb1"
    sha256 cellar: :any,                 arm64_big_sur:  "0aefe3bc18e877529c4558690872dc6427668830b49b234d3dfdc0fffc5994a4"
    sha256 cellar: :any,                 monterey:       "d605eab89cf11209f25aab6eb4f371c0b345f5927132e5ff1a3e71d40b369a13"
    sha256 cellar: :any,                 big_sur:        "0d781494db579b7a7297840ab2a899dde515a12f2c42e2e47d6c941830692815"
    sha256 cellar: :any,                 catalina:       "c27046441db151b7f36a23b4685b4e30de6e7b8223306e5a7837353b3f7cc077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38ae3063265cd6fd3d177a482053e27d90891797cbc78513bcd8ed3651204e98"
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
