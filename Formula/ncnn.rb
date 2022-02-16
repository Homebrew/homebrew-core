class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20220216.tar.gz"
  sha256 "3c1e6155f37292b5b908f8538cb0791a8b4d9cbc9c508b5ff69e41f106e2a372"
  license "BSD-3-Clause"
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3d1c2c65ad69481855c8f0e0bc8d29416da865a318303b5810d68b8fd28f99b2"
    sha256 cellar: :any,                 arm64_big_sur:  "0599f69f9e46b10b02d5743e755b2fa04fb678f042bfef28c8d44d6dbd7c011f"
    sha256 cellar: :any,                 monterey:       "33af0b2928a648abf4e52dbc0591c5e59538bb4776c6eb4bffa62a03e201cc99"
    sha256 cellar: :any,                 big_sur:        "cfd081a9f12444dda227887013fe8dc4cb5305f82c188a765f15f6c91933a2e5"
    sha256 cellar: :any,                 catalina:       "68443a0cc213d62524bba7c854c319e753062fa5939eace87685d2d390b00c62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "958ef420a03d104ee9cd5d7d04c8e54f9e1cc17a6db830b8d02c75473a392b14"
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
