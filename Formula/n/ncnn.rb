class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20240410.tar.gz"
  sha256 "328fe282b98457d85ab56184fa896467f6bf640d4e48e91fcefc8d31889f92b7"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0db4806cfea52b5ee55c3252fa8bfc03bf62a349d10205b2a4587ca83b672c18"
    sha256 cellar: :any,                 arm64_ventura:  "b218f71a3bb16616a1ce94547caa7aeceedf627b0dbe9157cdebf64f68747321"
    sha256 cellar: :any,                 arm64_monterey: "fc5e710223b15899a3e727ebc12ad08159c9bb55124468c8534f4fbae583e579"
    sha256 cellar: :any,                 sonoma:         "d6ba228bc084f5b560822145dffb76974de32926f61a630dcc4187818d127bbd"
    sha256 cellar: :any,                 ventura:        "ca660c635d6f76dee92f7b12678354a1422878c1e440eeaad300e0bde2b896f6"
    sha256 cellar: :any,                 monterey:       "9d1f1848f217064585dbe866fb8d83c1cd5cdfb97b4e24511da6930aa41473d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e0b99ac046064206ab03f9d37e5fbce59760da4503d76618a0562857c95bbf6"
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
