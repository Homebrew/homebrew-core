class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20240102.tar.gz"
  sha256 "0770b0b4ccbcb2b4e5f38574bb6f1086b07d48958b10f289251e0359faa1d9cc"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "726378c08f413f558776cfdeadb20d0618a921060991e585b19f28e9f6cfd4dc"
    sha256 cellar: :any,                 arm64_ventura:  "a0a5a56b1112bd5ea3ae41f17402544a6189312285026ca690f2254a47eb97d9"
    sha256 cellar: :any,                 arm64_monterey: "74501b0548837ab941ef99b038011db6abdaf9d5d1b7a8f505d18fa7ea311068"
    sha256 cellar: :any,                 sonoma:         "a6d1f98ac03148a4f33dade65c119d1a21a52e76f7025cc6a6438e48c64c843a"
    sha256 cellar: :any,                 ventura:        "7c92dabdeea917681b140980c94a3f008f757a14dcce8d52039eaf2723025284"
    sha256 cellar: :any,                 monterey:       "58749f38f09bd644778db2b3ac9173bc1af923f4b24b66422e1bc652636e5044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe41cf25ee874cc4c7defdf965fa6c6663ff4bcbe44e5ef1ffe31fc1b5a8cf83"
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
