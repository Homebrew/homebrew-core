class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20230816.tar.gz"
  sha256 "6b14105b6aba1e5fc87321b161c1d996c507f9b671a961831c8cd9987e807aa1"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5474a589394ea7e3e41eb9af6fea6d2d5cb4941a30ef3d6946c0a80d97ba4d85"
    sha256 cellar: :any,                 arm64_monterey: "7af59ce0f722349ee1cd0cee9ba6063e17e8ccf867076570d57a4f67ad69de61"
    sha256 cellar: :any,                 arm64_big_sur:  "bd1a326c5d76f1b7c0083ecaf67583763f741347d8d57f1bf53a2f3703c9583a"
    sha256 cellar: :any,                 ventura:        "24dae11ec769b5c94ec9a337116757e55b76a8a9d6afffa8b1afd630a18c4d35"
    sha256 cellar: :any,                 monterey:       "ae35181c148bed74065389edd9c20fd15d0672118c84cd829adf6f99380b3b65"
    sha256 cellar: :any,                 big_sur:        "fe55414d2634afde9166571bcdb2802d536799fc0b71b44a7a1097cbc988a66b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ab69c7626395f001aa18214aae3bd5704e39dbfd04e4952e94e1aeb923c72a1"
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
    # fix `libabsl_log_internal_check_op.so.2301.0.0: error adding symbols: DSO missing from command line` error
    # https://stackoverflow.com/a/55086637
    ENV.append "LDFLAGS", "-Wl,--copy-dt-needed-entries" if OS.linux?

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
