class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20240410.tar.gz"
  sha256 "328fe282b98457d85ab56184fa896467f6bf640d4e48e91fcefc8d31889f92b7"
  license "BSD-3-Clause"
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2f0eeec3233a7ba1f93f55165daa93932dc7e9736991f27359b1308f54037d09"
    sha256 cellar: :any,                 arm64_ventura:  "c83399e8210744e6580aef6e59303dd1f0b5b9065aff48885742b009b04a94f9"
    sha256 cellar: :any,                 arm64_monterey: "234cf087f225ff0830829a03e01e9b87a4a025dcf638eafd5629af8e7cfce799"
    sha256 cellar: :any,                 sonoma:         "ba2ae2c5fa17a4e1368358580328ce14d111103024b29b199fb65d3c31970289"
    sha256 cellar: :any,                 ventura:        "fef9688e0ce1658c0f8bcb4a32f9effee1cc7375240b3ed8ed17ac9a7e3467b1"
    sha256 cellar: :any,                 monterey:       "f5df4214be77343a8c412fecf1ca60844c9747e65156a53f98e7155946137295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dc0ff5fd2c705a6300e063b5a989b6e8e2f22f3c2a385f2d21bc88b4202f05b"
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
