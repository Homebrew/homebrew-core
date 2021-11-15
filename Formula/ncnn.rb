class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20210720.tar.gz"
  sha256 "a3f356a4efbdd26bac3f36229efb39d3d87e7d82b3bd855dbd2316152ce27024"
  license "BSD-3-Clause"
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "aa95a8ef317444cbd748d72cbcf1db1631dc96ea550386e05901d0ef6916f685"
    sha256 cellar: :any,                 arm64_big_sur:  "257ecbf447043abb37bf4c636d6783d0e6eb80daf9b739c1ef17e059608cdfe2"
    sha256 cellar: :any,                 monterey:       "4931037617d8b07d4c0ee849497a9e4ca2450991cfa837bdc8cb10304d0e8fb8"
    sha256 cellar: :any,                 big_sur:        "9fb4f2c59bd74b5e9b25f0937a23dcc926ebefba9ae1df98c88e39bfa2b2860d"
    sha256 cellar: :any,                 catalina:       "88fc1b23102c67d050648d25028e25805784101a113a0494dc008e62b178e347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62b98d0349313214e3ee12ba8f88c0bf47e4eaa11c465a1e203e260ebc6f375a"
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
