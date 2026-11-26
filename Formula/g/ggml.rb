class Ggml < Formula
  desc "Tensor library for machine learning"
  homepage "https://github.com/ggml-org/ggml"
  url "https://github.com/ggml-org/ggml/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "ee3f83e4839e4be8201fd87019855d70713362b7b657d2fde283d95274a7b8b3"
  license "MIT"
  compatibility_version 2
  head "https://github.com/ggml-org/ggml.git", branch: "master"

  bottle do
    manifest_sha256 "0591faa00960f4961b3f2f904e85bc456d9d367ad5188fc7adf0a17dec2e1093"
    sha256 arm64_golden_gate: "2aeb3e8342ddb339042e9be9f3b0265f89e347b6b3350615d5da0ed3503267fd"
    sha256 arm64_tahoe:       "e848998cf2b7b3ad2ab2034c704fca24319dccb08dbf290d3a81c5e6dce68937"
    sha256 arm64_sequoia:     "191b33f51795633f257c317a6ba10d9ce852e20db0a823e93e636ad56ca80fa3"
    sha256 arm64_linux:       "e062473575f08811286ec4e8f7c8d7fb7b4437295da5532aa8311d811f70da79"
    sha256 x86_64_linux:      "3148e15b86de817d5bde62ebcf19736ca638704771d8c8d37a61cb9b55514a16"
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

  on_arm do
    fails_with :gcc do
      version "13"
      cause "error: invalid feature modifier 'sme' in '-march=armv9.2-a+dotprod+i8mm+nosve+sme'"
    end
  end

  # These were previously provided by `llama.cpp`
  link_overwrite "include/ggml*", "include/gguf.h", "lib/cmake/ggml/", "lib/libggml*"

  # Lengthy test so not worth installing. Shorter examples/tests haven't been ported to new DL backend
  resource "test-backend-ops.cpp", :test do
    url "https://raw.githubusercontent.com/ggml-org/ggml/refs/tags/v1.1.1/tests/test-backend-ops.cpp"
    sha256 "1cc063005180538a13860ea2b90d6507bee6fcc989a19e8835bfcfa310e4877a"

    livecheck do
      formula :parent
    end
  end

  allow_network_access! :test

  def install
    # CPU detection is needed to build multiple backends, particularly on ARM (e.g. `-march=armv8.x-a+...`)
    ENV.runtime_cpu_detection

    # Build bottle with Ubuntu GCC 14 rather than indirect brew GCC as latter can impact C++ ABI used
    # TODO: Remove once CI defaults to GCC 14+
    ENV.method(:"gcc-14").call if OS.linux? && Hardware::CPU.arm? && ENV["HOMEBREW_GITHUB_ACTIONS"]

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
    args << "-DGGML_CPU_ALL_VARIANTS=ON" if build.bottle?

    # Enabling OpenBLAS for BLAS support and Vulkan for GPU support on Linux
    args += %w[-DGGML_BLAS_VENDOR=OpenBLAS -DGGML_VULKAN=ON] if OS.linux?

    # Not building Metal backend and Sapphire Rapids on Intel macOS
    if OS.mac? && Hardware::CPU.intel?
      args += %w[-DGGML_METAL=OFF -DGGML_METAL_EMBED_LIBRARY=ON]
      inreplace "src/CMakeLists.txt", /^(\s*)(ggml_add_cpu_backend_variant\(sapphirerapids)/, "\\1# \\2"
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

    ENV.method(DevelopmentTools.default_compiler).call if OS.linux? && Hardware::CPU.arm?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    assert_match(/[1-9] backends passed/, shell_output("./build/test -o ABS"))
  end
end
