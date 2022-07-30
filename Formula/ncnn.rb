class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20220729.tar.gz"
  sha256 "fa337dce2db3aea82749633322c3572490a86d6f2e144e53aba03480f651991f"
  license "BSD-3-Clause"
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b3200b2d97dabe9e083d6cd02671a8da60a4b8569b4767bfecd464f35bf6c304"
    sha256 cellar: :any,                 arm64_big_sur:  "c61c26dade8d576acb46ac54463624f748ffe0bf27dbd2361fa62ae07e1454d2"
    sha256 cellar: :any,                 monterey:       "904f53f63dcf76e1caf0eb3d28b77157e07c11f6289d3dd795c1bb2262881029"
    sha256 cellar: :any,                 big_sur:        "525516d64ead0ebf799f86f5a7e03296a0d4c591258b595161cf53484744e542"
    sha256 cellar: :any,                 catalina:       "50c95913ce60c8ff6c1e90ae2c7d7ef47c3b4b58d92ea3ec2374246711d2715d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7853ebf30a23c727d327adb0889234b0557b1b0ef8e88b1445841f6dee835218"
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
