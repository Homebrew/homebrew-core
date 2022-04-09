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
    sha256 cellar: :any,                 arm64_monterey: "5817b21eef47792e11597da08925902336d99fca94125fa80c722d5334f799de"
    sha256 cellar: :any,                 arm64_big_sur:  "459ee4ff5095d1c8050b17413bdafcf4969b3956e636f84a7c1f98af87e892fd"
    sha256 cellar: :any,                 monterey:       "3d70898f0aefa81b3431fa2b6349ffac25a6c03aeca09389c6d2a8f4e14cadc7"
    sha256 cellar: :any,                 big_sur:        "00d77c4048689717574dd1de7c632b5ca7e19573dadf7a0c1195c225316c43a9"
    sha256 cellar: :any,                 catalina:       "b268057d08855d1b6a720b477eb265a462f2b7bea9bb8c5a67460bf6ac6401be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80ed8b1c18469c379c7149bdc733664f2bf56cba4a2a268ef4fe13ddba9c5442"
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
