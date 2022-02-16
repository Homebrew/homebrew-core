class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20220216.tar.gz"
  sha256 "3c1e6155f37292b5b908f8538cb0791a8b4d9cbc9c508b5ff69e41f106e2a372"
  license "BSD-3-Clause"
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bea2ae4a528d0d80cca1bc5d76fcc49eee89d8622983adbaede73b8cabbc2a32"
    sha256 cellar: :any,                 arm64_big_sur:  "3b2ace104fee555142786d022be8ff9b882bdca6e3dc088e82064a8ac78043ea"
    sha256 cellar: :any,                 monterey:       "511d520641156e822ee7818cf8809301beab07f9b7ea4e8487a30c52240d0b46"
    sha256 cellar: :any,                 big_sur:        "d54512b5c612a7f576b9dfe4fc51e43705e85e089be61460dc9aeddcf3b954b0"
    sha256 cellar: :any,                 catalina:       "88940c4005ebb130e305cd647c50b999094734c1e3146665ce0c0d5c17c01078"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd806e5fdc52d219fffe865b240b7ad31f872e31d72da707f5381614fdf4d981"
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
