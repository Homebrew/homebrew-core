class Ggml < Formula
  desc "Tensor library for machine learning"
  homepage "https://github.com/ggml-org/ggml"
  url "https://github.com/ggml-org/ggml/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "ae3f37f599acc16e8213d728f66528c7ba7a9ff2d7cac09181ba1ab19adb445c"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ggml-org/ggml.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "d7e8b0617c0722d9b2e5f81d3597df2bcae2a866ce63a3d22e4b5b7d8a8d9f7a"
    sha256 arm64_sequoia: "e9db3752c2cb508d9f1535f57bf388281db25b323570cfaf494bb4ec3f8c85ab"
    sha256 arm64_sonoma:  "efcf1777bd679f6bb0b90a7d6d48041d4bdae725bcaeebb0cd781e09d80bfa36"
    sha256 arm64_linux:   "69c278705bc836969a6309b5611c49f8bec2fa3b74df67f8f28debebd0db5ce7"
    sha256 x86_64_linux:  "d368d1cac4bcc908782bf68456c41a1fd9781d55d545c2eec7e546b64ecad7cb"
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
  resource "test-backend-ops.cpp" do
    url "https://raw.githubusercontent.com/ggml-org/ggml/refs/tags/v0.23.0/tests/test-backend-ops.cpp"
    sha256 "3d59bee564acf41c748280bf9fa8e3f3626d1666884bc5fd342153cf3eec24a1"

    livecheck do
      formula :parent
    end
  end

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
