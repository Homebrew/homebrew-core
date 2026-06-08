class Ggml < Formula
  desc "Tensor library for machine learning"
  homepage "https://github.com/ggml-org/ggml"
  url "https://github.com/ggml-org/ggml/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "ce4c6d51902d6379568ce4ce39700a6f948d9969ca2b0ded026adc88b10bd266"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ggml-org/ggml.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "705430393590f76e5d2708ec7a0f1b4c3216e0a05c3319747378f4b79e48fe71"
    sha256 arm64_sequoia: "04e72b9aadef2bfa56a24d872e0bf84a4346d8dd95688188a0d52296b995e3bf"
    sha256 arm64_sonoma:  "c510c4e73b86b6ee5dce5469c19515b521e557a9493b0518cbe5b64e61bbc2a1"
    sha256 sonoma:        "e781f143fcd2ce6f9eb7ecac602c99c68a2da862e7a6f398026e7244f46b0bdc"
    sha256 arm64_linux:   "cd6f8785abe4191847698697fdf4262a0e436a3b9057c91ea84565ea75984775"
    sha256 x86_64_linux:  "b68e094921c077e266f9cd02cf1b6e6709b2b900a8636cfd6f31526914604caf"
  end

  depends_on "cmake" => [:build, :test]

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "shaderc" => :build
    depends_on "openblas"
    depends_on "spirv-headers"
    depends_on "vulkan-loader"
  end

  # These were previously provided by `llama.cpp`
  link_overwrite "include/ggml*", "include/gguf.h", "lib/cmake/ggml/", "lib/libggml*"

  # Lengthy test so not worth installing. Shorter examples/tests haven't been ported to new DL backend
  resource "test-backend-ops.cpp" do
    url "https://raw.githubusercontent.com/ggml-org/ggml/refs/tags/v0.13.1/tests/test-backend-ops.cpp"
    sha256 "64f5adb2b78f9858482ba02ea390f4df61123feeb0550f6b1ae48a91923028df"

    livecheck do
      formula :parent
    end
  end

  def install
    # CPU detection is needed to build multiple backends, particularly on ARM (e.g. `-march=armv8.x-a+...`)
    ENV.runtime_cpu_detection

    # TODO: Workaround for GCC 12 as armv9.2-a was added in GCC 13. Remove after Ubuntu 24.04 migration
    if Hardware::CPU.arm? && ENV.compiler.to_s.start_with?("gcc") && DevelopmentTools.gcc_version(ENV.compiler) < 13
      inreplace "src/ggml-cpu/CMakeLists.txt", "if (GGML_INTERNAL_SME)", "if (OFF)"
    end

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DGGML_ALL_WARNINGS=OFF
      -DGGML_BACKEND_DIR=#{libexec}
      -DGGML_BACKEND_DL=ON
      -DGGML_BLAS=ON
      -DGGML_BUILD_EXAMPLES=OFF
      -DGGML_BUILD_TESTS=OFF
      -DGGML_CCACHE=OFF
      -DGGML_LTO=ON
      -DGGML_NATIVE=OFF
    ]

    # Enabling OpenBLAS for BLAS support and Vulkan for GPU support on Linux
    args += %w[-DGGML_BLAS_VENDOR=OpenBLAS -DGGML_VULKAN=ON] if OS.linux?

    # Not building Metal backend and CPU variants on Intel macOS
    if OS.mac? && Hardware::CPU.intel?
      args += %w[-DGGML_METAL=OFF -DGGML_METAL_EMBED_LIBRARY=ON]
    elsif build.bottle?
      args << "-DGGML_CPU_ALL_VARIANTS=ON"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    testpath.install resource("test-backend-ops.cpp")

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)
      find_package(ggml REQUIRED)
      add_executable(test test-backend-ops.cpp)
      target_link_libraries(test PRIVATE ggml::ggml)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    assert_match(/[1-9] backends passed/, shell_output("./build/test -o ABS"))
  end
end
