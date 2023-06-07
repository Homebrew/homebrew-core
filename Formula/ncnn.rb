class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20230517.tar.gz"
  sha256 "71c1960e5fbbe68d2c3cf572cbf4dd08bb387ef20d2c560c074c5969c6b44bde"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ed2692c1a67318b5218593d057af9153a48b9df731d0e1058c004728ea9c4cba"
    sha256 cellar: :any,                 arm64_monterey: "24c3b2a927d6a37089bf356074d3482223cfb8f3dc8ab5a82994a6d7cf40386f"
    sha256 cellar: :any,                 arm64_big_sur:  "a49e000aaa89bdb6ba2f9444aa6fe044f8c7cc2d3aeade99f7897be99d423f37"
    sha256 cellar: :any,                 ventura:        "4c2d84274d55fa4bc0df27d32fe5c23a8b944fbc70a5b000fc77fd97dbb0219f"
    sha256 cellar: :any,                 monterey:       "67fe161648c66a67498703f993417cb86444d08818401f7010addcdd3c1935b5"
    sha256 cellar: :any,                 big_sur:        "15d8f63b196d40b59d473380a1bf8a77300368f33c9fad1b0c36a66f1dfc8f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b93d162a55925582e4ac57ed0b3a935d62962337f0a3d55d38018bb3a82e6a8"
  end

  depends_on "cmake" => :build
  depends_on "protobuf@21"

  on_macos do
    depends_on "glslang" => :build
    depends_on "vulkan-headers" => [:build, :test]
    depends_on "libomp"
    depends_on "molten-vk"
  end

  def install
    args = std_cmake_args + %w[
      -DCMAKE_CXX_STANDARD=11
      -DCMAKE_CXX_STANDARD_REQUIRED=ON
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
