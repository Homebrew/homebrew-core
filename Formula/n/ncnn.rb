class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20230816.tar.gz"
  sha256 "6b14105b6aba1e5fc87321b161c1d996c507f9b671a961831c8cd9987e807aa1"
  license "BSD-3-Clause"
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9f88efbbcd39c6af44cfa83f2f283cb805a0972a90dc2db9c54c8d42fd442479"
    sha256 cellar: :any,                 arm64_monterey: "fed58c3656d787a0a89c7e5cee42503120f2a7d4376bc2ccc10e27f314acacaf"
    sha256 cellar: :any,                 arm64_big_sur:  "5365b7b45976bb40ab802712740a1bef9f6ea24b2197cb89745ffb495c827c2a"
    sha256 cellar: :any,                 ventura:        "b40aee63254c378d8d0002238a1a37fad0de02238a8c3a8e403b55b82514ce2c"
    sha256 cellar: :any,                 monterey:       "229ab25dd2b47cb6e88d6d9adfd30067931c67fffeb0dd583e595445771110fc"
    sha256 cellar: :any,                 big_sur:        "dbda185fb84e45bcf806d0044955c12c87cc9dc3efffdddfd19d8d221f240fa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "849e034743437d789b6c29547a60ad8953f3cba683e45563c7c316203550eb07"
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
