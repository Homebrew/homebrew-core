class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20240410.tar.gz"
  sha256 "328fe282b98457d85ab56184fa896467f6bf640d4e48e91fcefc8d31889f92b7"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2b1b4cf2e7b021ded641b78ebc684cd272f6ca46f15e037b799352bb849ce3ab"
    sha256 cellar: :any,                 arm64_ventura:  "fccbbfbfbc34a41d61331fb514f36620c876316afb81f942754d92fd61d01abf"
    sha256 cellar: :any,                 arm64_monterey: "d88f770e5e781a85cbca85a6e204f0384180516053625069e2565c0f51deebde"
    sha256 cellar: :any,                 sonoma:         "eb27cb34cff0a730e4adddf6e832079fc565b78e88fcbb3dc3fc3d3d317779d2"
    sha256 cellar: :any,                 ventura:        "3545e17eaef9f6d81c16eff608174f19493a27fe8c6dd702217f5d3c8b6cef61"
    sha256 cellar: :any,                 monterey:       "b42f877e01f17f0ca405c382c440bd0b6dd95f78e174c493b885b7cbc63925d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2982ef20468deb1ebf189acde73d36f97dfdcc636332f9ef8b792b9fc511c672"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"

  on_macos do
    depends_on "vulkan-headers" => [:build, :test]
    depends_on "abseil"
    depends_on "glslang"
    depends_on "libomp"
    depends_on "molten-vk"
    depends_on "spirv-tools"
  end

  def install
    # fix `libabsl_log_internal_check_op.so.2301.0.0: error adding symbols: DSO missing from command line` error
    # https://stackoverflow.com/a/55086637
    ENV.append "LDFLAGS", "-Wl,--copy-dt-needed-entries" if OS.linux?

    args = %W[
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_CXX_STANDARD_REQUIRED=ON
      -DNCNN_SHARED_LIB=ON
      -DNCNN_BUILD_BENCHMARK=OFF
      -DNCNN_BUILD_EXAMPLES=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
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
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
