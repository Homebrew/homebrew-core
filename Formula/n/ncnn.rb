class Ncnn < Formula
  desc "High-performance neural network inference framework"
  homepage "https://github.com/Tencent/ncnn"
  url "https://github.com/Tencent/ncnn/archive/refs/tags/20250503.tar.gz"
  sha256 "3afea4cf092ce97d06305b72c6affbcfb3530f536ae8e81a4f22007d82b729e9"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/Tencent/ncnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "591c107a665b5dde884b4f70f8a4663937aa6ea93bc99707a00f1bf36faf937d"
    sha256 cellar: :any,                 arm64_sonoma:  "cdb1625dd61aa7a56117bc3280f542cb68c832d8e0bd86b888462b6fe6f3dc2d"
    sha256 cellar: :any,                 arm64_ventura: "4020b0258ee0c27140a46a8a5c4bdc695e7002bb53e362a38582aea0cd846694"
    sha256 cellar: :any,                 sonoma:        "7aaf460db574e7dbbd045ec550def2c5d7b96d62cccc2b3049048caf16b4fb24"
    sha256 cellar: :any,                 ventura:       "31a6164e307ada34251e493a66b299be46598039e842f41caa24b55088c6cbfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8017684ff0ae53f5488652459ff7740e1c07767624cc90a33d6815031d05030a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c2190aacc1ba6e0fc4099fa5a5c5b21a9e49d5fcb78ea777f2973ab094d5d57"
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
