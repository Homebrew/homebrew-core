class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20220420.tar.gz"
  sha256 "51d562a87b0c4d146902ec7b4f9fba5f6ec602f31f11e427f0524622f2503232"
  license "BSD-3-Clause"
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1eba5b37f3700abb3eadc7a35a66178cd45f92f97bd2e2fbefac795f295e9a58"
    sha256 cellar: :any,                 arm64_big_sur:  "fce92377c0be9865f78a0d9862d1f1cef3366f97585e0b1ee9f5923f87f699a9"
    sha256 cellar: :any,                 monterey:       "772bbf547132135fa2d979a901d0601bb19175a57751bd3364e3ecb81feaafb6"
    sha256 cellar: :any,                 big_sur:        "89b1322ddd3dd273070e444ac53d7cb1b9df4096ae0e0b0d3397044ad3ae8c91"
    sha256 cellar: :any,                 catalina:       "02f2cbebc76a5a561210eaca66b60fa4804001a9a12c99bcc9cef238f61ec2b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f25d5b693f3fe63226fd25036ecbf1c12b028b2e1c4b81f652a9e9c9e3a7cb5"
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
