class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20220721.tar.gz"
  sha256 "67d0331203c5041e25526e9a1cb879779024ce262439c5cc80aa7f1e8650524e"
  license "BSD-3-Clause"
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e6aa285ab2b6f4bfde55d5beef3c0fa08b7496f2919ee9471c4664c1610f2150"
    sha256 cellar: :any,                 arm64_big_sur:  "9ac3d35fff5cc43e5ac8cc1182fd68d5271cd7b34bb521cb352435cd3ae862eb"
    sha256 cellar: :any,                 monterey:       "25444eb1e943fa6de532e5ddf8e0544939ef90ee854708cf1fbbb84a01deccaa"
    sha256 cellar: :any,                 big_sur:        "ab7a79739ec6ff29197d0d2444e1d28d8d00fb12121acc6b7ea026e35951d3bb"
    sha256 cellar: :any,                 catalina:       "fea009a8e6e7838c490141a05d45afedef2069bcf5c394e1673971137f926918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "701ccc82fed2b734dea00d8f3a4604317745c48c9967345d14703bdcbfa82219"
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
