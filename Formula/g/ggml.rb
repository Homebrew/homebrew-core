class Ggml < Formula
  desc "Tensor library for machine learning"
  homepage "https://github.com/ggml-org/ggml"
  url "https://github.com/ggml-org/ggml/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "65b602073408cd8b5365e6592d6c244bf75647e8c06b96c1f7c5657e314df3c5"
  license "MIT"
  compatibility_version 2
  head "https://github.com/ggml-org/ggml.git", branch: "master"

  bottle do
    manifest_sha256 "b7bf9d8799d4647df1a09413776b7daa864b726d87e54583818306f5e2616cf6"
    sha256 arm64_golden_gate: "97bd2cd15aa3d8306d376d463c20bb898f361cfcb8f3d794192487680a40b38d"
    sha256 arm64_tahoe:       "da2d1006dd06816224037ef39b849f8380979e2f9bdf01dffacac4d8658df4fc"
    sha256 arm64_sequoia:     "0798556608717dcf914e1e997038834be3d1ac96d8278d68c3807e2c6d013019"
    sha256 arm64_linux:       "f27d12fcd9ed251d0cacf50036a995d4da28393cd83a4814be861aabaf3c9e41"
    sha256 x86_64_linux:      "8f347361c97c5baabc5c16afb5dcdb9cccef0eba32134fc197182afa8e558c29"
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
    url "https://raw.githubusercontent.com/ggml-org/ggml/refs/tags/v1.1.0/tests/test-backend-ops.cpp"
    sha256 "361656fd009d41a5119d618ec954bac3288a670ded23ad0949cd90955a9cbdd2"

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
