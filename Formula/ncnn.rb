class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20230223.tar.gz"
  sha256 "134cbb1048ae5613d378b67455a4b493b6236fc206ec1445215af008a01a654e"
  license "BSD-3-Clause"
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1866c8654a740ac3bce46b30d998f025ba3ebf4c961c2d0a1a38a6f00b7a03ef"
    sha256 cellar: :any,                 arm64_monterey: "f931191fded84e2e591dd34376661133bb3cf346f007e5c45ff9c169666017f8"
    sha256 cellar: :any,                 arm64_big_sur:  "d47831ef263fdda3d46e58945969c9347ea0f6ce4c8f3032108372dc0e0900e8"
    sha256 cellar: :any,                 ventura:        "d947306986418fe4996a1d2219116879cc0511af22369f40539ded6e2997aa69"
    sha256 cellar: :any,                 monterey:       "3162f692c8792eab68d92b7dfa34ad72a4b8543fa92a02e8ca0bbdf865afe31e"
    sha256 cellar: :any,                 big_sur:        "0efa8a2d1d230014bdde60dd83f9bfa70882e434440a18f386068ebb80d6cc07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43a8a442a7eaf8e379ad10a7356c94586a15143d3b393131fb29e279f777c452"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"

  on_macos do
    depends_on "glslang" => :build
    depends_on "vulkan-headers" => [:build, :test]
    depends_on "libomp"
    depends_on "molten-vk"
  end

  def install
    ENV.cxx11

    args = std_cmake_args + %w[
      -DNCNN_SHARED_LIB=ON
      -DNCNN_BUILD_BENCHMARK=OFF
      -DNCNN_BUILD_EXAMPLES=OFF
    ]

    if OS.mac?
      args += %W[
        -DNCNN_SYSTEM_GLSLANG=ON
        -DGLSLANG_TARGET_DIR=#{Formula["glslang"].opt_lib/"cmake"}
        -DNCNN_VULKAN=ON
        -DVulkan_INCLUDE_DIR=#{Formula["molten-vk"].opt_include}
        -DVulkan_LIBRARY=#{Formula["molten-vk"].opt_lib/shared_library("libMoltenVK")}
      ]
    end

    inreplace "src/gpu.cpp", "glslang/glslang", "glslang"
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ncnn/mat.h>

      int main(void) {
          ncnn::Mat myMat = ncnn::Mat(500, 500);
          myMat.fill(1);
          ncnn::Mat myMatClone = myMat.clone();
          myMat.release();
          myMatClone.release();
          return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11",
                    "-I#{Formula["vulkan-headers"].opt_include}", "-I#{include}", "-L#{lib}", "-lncnn",
                    "-o", "test"
    system "./test"
  end
end
