class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20240102.tar.gz"
  sha256 "0770b0b4ccbcb2b4e5f38574bb6f1086b07d48958b10f289251e0359faa1d9cc"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "242b2cdd8211e5f6b21060f01c060c548452dc878ced378a901bc85b3f97b0c6"
    sha256 cellar: :any,                 arm64_ventura:  "5dea0274cc71273e923edac627b1974814b7193bb39ab80c11775a2aae2cbc15"
    sha256 cellar: :any,                 arm64_monterey: "597c3e8f5340fb9c7589b2ddc580041a1540b9d9c03c173233a8ba1864bb1c3e"
    sha256 cellar: :any,                 sonoma:         "1b8de1c260408c3a1356abdaed5a3c7ed6e34358a003487d4949ac1951112cee"
    sha256 cellar: :any,                 ventura:        "0b394ccef6e5266901b7a1dbc092d0df844ef96cad3077e91f3db3c368954f10"
    sha256 cellar: :any,                 monterey:       "188cc903ccfc59e7aaaf2f7fce83d5da9cae95b33d849be4c737e8c017bdfc82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a4991e3f125162730bcfa2e1e5c62f6fbf37a2f07e4bf3cfb9badabf384bd47"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"

  on_macos do
    depends_on "vulkan-headers" => [:build, :test]
    depends_on "glslang"
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
