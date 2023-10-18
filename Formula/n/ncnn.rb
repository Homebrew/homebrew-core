class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20230816.tar.gz"
  sha256 "6b14105b6aba1e5fc87321b161c1d996c507f9b671a961831c8cd9987e807aa1"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "927ec9264fd5304f39cb9108fac2f207cffd32b4ee090dbb56b9a4f517d697fa"
    sha256 cellar: :any,                 arm64_ventura:  "4d50a6082c220a26b3f890e23df5a6e11af3b34ebcedeab33bad12bb503da991"
    sha256 cellar: :any,                 arm64_monterey: "e983316689a2eb5856e4a806e07fd6b1cb71e7ba26283d128f6fb09ad67c7c46"
    sha256 cellar: :any,                 sonoma:         "a8f2aa447ed1b3c1c21dd771baa0e5e4f5a41a7db9abd085de5400774401c923"
    sha256 cellar: :any,                 ventura:        "b3f440ac03991f4b33dd775041dc3597d5b82d1fce970ccc4cafac381c2e4f02"
    sha256 cellar: :any,                 monterey:       "0ac34904b4afe4689cb94c6f99094190b1079fbea3b1645de3e6c4235e59a2a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e2348b41c79e47297efab3b7a8045de381744014d61e36b24669c1d7a1a6e27"
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
