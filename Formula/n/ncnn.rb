class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20240102.tar.gz"
  sha256 "0770b0b4ccbcb2b4e5f38574bb6f1086b07d48958b10f289251e0359faa1d9cc"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d75c2a159a4cc1bf1165d302e0bfcb7acc00ec12f52c8dcb67937d078442a01d"
    sha256 cellar: :any,                 arm64_ventura:  "e7eedcc6b672d4f4ff40cba7b3984278ec06351f4c37325bdcd5502744fc7d32"
    sha256 cellar: :any,                 arm64_monterey: "22f9bce91742fb03cd129183af65469f9df0afed7a0330b363aae81f761c135d"
    sha256 cellar: :any,                 sonoma:         "adb02b8a3bc4ded55fda3ba649698a344fb87b04a99ec9c1dad08c4aeb732bfa"
    sha256 cellar: :any,                 ventura:        "9146f293dd438018a14742144a5cc17c8867d81bf249501c5e37d76a8cff80a1"
    sha256 cellar: :any,                 monterey:       "d8d7206c842938769ac837f9a1a97e631d0cc0baa03ba1d9feabd8999c58870b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efe18a3790d5d8414992641259b7cf4637f3cbddcd7c35d197a1763ed94c646a"
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
      -DCMAKE_CXX_STANDARD=17
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
