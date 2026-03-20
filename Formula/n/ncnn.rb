class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20260113.tar.gz"
  sha256 "2fdc5c6e37f8552921a9daad498a1be54a6fa6edd32c1a9e3030b27fab253b47"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0a30245d91ba241ced71357eef70d71088174379b75884b05ec50405acfa7d4c"
    sha256 cellar: :any, arm64_sequoia: "8a6f15c5a2a00e77b4d0ecab6cbb73a4b032d8f9cb571ffd3dcb5907d2d12a8d"
    sha256 cellar: :any, arm64_sonoma:  "5944d34565903b7d44f7cf40b41456b07044c6666bcbc1efbc5f5dc6090e0600"
    sha256 cellar: :any, sonoma:        "bc073df7e707231c4c1a0d13ca482fc77dcbc42deda8aff02d4f7afd7dea3088"
    sha256               arm64_linux:   "9e31cf41ae4f89877a0f285c4f5e85511b68e07a270299886dc6e98e2179e976"
    sha256               x86_64_linux:  "cd30b97698afaf3267d49d3f9af6142e830ee5ad2911b5e0ef45a4bf98e1cd65"
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
    elsif Hardware::CPU.arm? && MacOS.version == :sonoma
      # Disable Metal argument buffers for macOS Sonoma on arm
      ENV["MVK_CONFIG_USE_METAL_ARGUMENT_BUFFERS"] = "0"
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
