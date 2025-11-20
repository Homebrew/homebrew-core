class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20250916.tar.gz"
  sha256 "7d463f1e5061facd02b8af5e792e059088695cdcfcc152c8f4892f6ffe5eab1a"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c97a05902ca7dffbfd03fb1ee2000d19b9c8b6d381b712b9e7d0940367284e68"
    sha256 cellar: :any, arm64_sequoia: "67e613b514a44b8ccc68eca7e567fc3c7927fdcaa9c58647812f5d44cb275e97"
    sha256 cellar: :any, arm64_sonoma:  "7a9b469f1647be5ffc37185b3dc383a8394f1bfba2b21254f27ffc74b5ac2ebc"
    sha256 cellar: :any, sonoma:        "10f0318b870aaf5e3a043cbbe51fe5e6b62397493cffabf920c7df3f53010337"
    sha256               arm64_linux:   "cebe755b72b9eaf9883cfb91fa0cb4605469e1e1ff58c601feb74b109866b0b4"
    sha256               x86_64_linux:  "65b0415c4137678debef920d6dc39bf0cb8fc7443238c6166cab279b37769417"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "glslang"
  depends_on "protobuf"

  on_macos do
    depends_on "libomp"
    depends_on "molten-vk"
    depends_on "spirv-tools"
  end

  on_linux do
    depends_on "vulkan-tools" => :test
  end

  def install
    # fix `libabsl_log_internal_check_op.so.2301.0.0: error adding symbols: DSO missing from command line` error
    # https://stackoverflow.com/a/55086637
    ENV.append "LDFLAGS", "-Wl,--copy-dt-needed-entries" if OS.linux?

    args = %W[
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_CXX_STANDARD_REQUIRED=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DNCNN_SHARED_LIB=ON
      -DNCNN_BUILD_BENCHMARK=OFF
      -DNCNN_BUILD_EXAMPLES=OFF
      -DNCNN_SYSTEM_GLSLANG=ON
      -DGLSLANG_TARGET_DIR=#{Formula["glslang"].opt_lib}/cmake
      -DNCNN_VULKAN=ON
    ]

    if OS.mac?
      args += %W[
        -DVulkan_INCLUDE_DIR=#{Formula["molten-vk"].opt_include}
        -DVulkan_LIBRARY=#{Formula["molten-vk"].opt_lib/shared_library("libMoltenVK")}
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    vulkan = 1
    if OS.linux?
      # Use a fake Vulkan ICD on Linux as it is lighter-weight than testing
      # with `vulkan-loader` and `mesa` (CPU/LLVMpipe) dependencies.
      ENV["VK_ICD_FILENAMES"] = Formula["vulkan-tools"].lib/"mock_icd/VkICD_mock_icd.json"
    elsif ENV["HOMEBREW_GITHUB_ACTIONS"] && Hardware::CPU.intel?
      # Don't test Vulkan on GitHub Intel macOS runners as they fail with: "vkCreateInstance failed -9"
      vulkan = 0
    end

    (testpath/"test.cpp").write <<~CPP
      #include <cassert>
      #include <ncnn/gpu.h>
      #include <ncnn/mat.h>

      int main(void) {
          ncnn::Mat myMat = ncnn::Mat(500, 500);
          myMat.fill(1);
          ncnn::Mat myMatClone = myMat.clone();
          myMat.release();
          myMatClone.release();

      #if #{vulkan}
          ncnn::create_gpu_instance();
          assert(ncnn::get_gpu_count() > 0);
          ncnn::destroy_gpu_instance();
      #endif

          return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11",
                    "-I#{include}", "-L#{lib}", "-lncnn",
                    "-o", "test"
    system "./test"
  end
end
