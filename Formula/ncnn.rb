class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20220729.tar.gz"
  sha256 "fa337dce2db3aea82749633322c3572490a86d6f2e144e53aba03480f651991f"
  license "BSD-3-Clause"
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d7024165d8efc6347eb3e3845151d55eec8e05b0d3055ccc1c92d7f9bd9f6906"
    sha256 cellar: :any,                 arm64_big_sur:  "a8b103a161937a153a8b6885c0170cd8c5379fbee0eeaf19a606300932e0474f"
    sha256 cellar: :any,                 monterey:       "c7e8c1d0a7d936168357ab0f91b933992a441abe388cbb69c6d6fd55aeff1804"
    sha256 cellar: :any,                 big_sur:        "9235acdddad23db3420c2a788d177cb23cb889d6974aa8af859939421a0f342a"
    sha256 cellar: :any,                 catalina:       "759c9876738cc1acbdcb4f9eede7bf9669d658543fa3939c90e5e724c847a0d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c5626197a6e1ae1a705713810c0ab9f70d2ab1262a05fa05a7e9bf80ef363b9"
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
