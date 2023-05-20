class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20230517.tar.gz"
  sha256 "71c1960e5fbbe68d2c3cf572cbf4dd08bb387ef20d2c560c074c5969c6b44bde"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5af4099898dfcadbe0f9f77e986f903e0149b94c6a51428a1c6887fd6aeaedb1"
    sha256 cellar: :any,                 arm64_monterey: "8b71e538cea7613bc1fd6c8194437f7333df907ecc0b3a8bfb907ca64e6cb639"
    sha256 cellar: :any,                 arm64_big_sur:  "5de4da4ff1a9dd3ef6d5e8e7b944b5ec47cec8b9ded385bffd731c42f402b004"
    sha256 cellar: :any,                 ventura:        "e820a43c3d41d9a5a2dc956904df36abf508dd6d1af84d40163e75e1ec2d8618"
    sha256 cellar: :any,                 monterey:       "2141833163a3df75c996dae3871dcbefb861d79f598321261d35bd21a38c46d4"
    sha256 cellar: :any,                 big_sur:        "586cd554e69238a29eb0fd3728f008482ab6a4ae35334083360acfb1f0467c9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e7c1437475510e52a9795fb49680aa144b9dc5569bbdb28861e45e040678b9c"
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
