class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20211208.tar.gz"
  sha256 "20d63bef0f87ef359d6f5dbd9fcfb7a81c3d98a27ec8ccb8ead6ec08188fe6ef"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bf4ed06b89345bf219b4af88999b0e55f773bb5da58761f9ac0b83795a3a8f4e"
    sha256 cellar: :any,                 arm64_big_sur:  "603210138b84d17e954710ba8315b2f5ac8f6c7e7c259c051da187718028538f"
    sha256 cellar: :any,                 monterey:       "b71a0ba39976915badd8cb88a78d26e37cfc96176d25b494c77b0e447737ca61"
    sha256 cellar: :any,                 big_sur:        "2da42973f453a17f58e932ae3be74e038555425e9a5bd39ae2e03451120b325b"
    sha256 cellar: :any,                 catalina:       "dc0de9b58777630e1d331b589278207a32db4852dec2d78f3e9c4ccd04b048e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2013a9dea4202c8a7f5d1cc7d66a8054fd56188f632d31bab3f424b3c9657e48"
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
