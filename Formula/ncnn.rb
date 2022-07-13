class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20220701.tar.gz"
  sha256 "e222f2ac54cc52ed7b1f6edc83ce4bf8ea1dc729c81f6a1560e4196032ec88ca"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ed8c87f06dde046ba0bf017db9cd85f570e59348e156241f8f3f0dba3aef1d27"
    sha256 cellar: :any,                 arm64_big_sur:  "802cb596e0f25ff01ea31c9cb7048344a77dd2e154382ba7e1139da23f23dc2c"
    sha256 cellar: :any,                 monterey:       "ece86caeb04fca6b93d2724baf36c2208bb0581c46921bfd4bc812882750b419"
    sha256 cellar: :any,                 big_sur:        "b36191efde141fa5f00921bd834efacf08f40acbefae4a2d0d41f1d1fb8eead3"
    sha256 cellar: :any,                 catalina:       "f1f0c550bcdd5c4eb24caf2c667da13ade41d74406057b0883fc0e02ec0e2897"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cce3576a4fe90a6c92e57bd349e19657125437c67f37b42835aa573442b0707c"
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
