class Ggml < Formula
  desc "Tensor library for machine learning"
  homepage "https://github.com/ggml-org/ggml"
  url "https://github.com/ggml-org/ggml/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "a91b9f826ba475b424793384a31027929c339a93e31df736bb98b82a92b14e12"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ggml-org/ggml.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "61de50a5259a2af583b30a0f47717ceaaa7806d4531855c93cbb87fd83a5c061"
    sha256 arm64_sequoia: "d625db731e163a8838ed63aa38e5051cfcef083c389827602b8fa3593476a37d"
    sha256 arm64_sonoma:  "e806f76bdf93e6bba86aba1ce0f1e0f50f3db993fb8ec5b914f84dae9a7497be"
    sha256 sonoma:        "756b1b44a493e27f3cbb91f0921378cda9c013c51f5c4fe2b5719c8698a3c68f"
    sha256 arm64_linux:   "2974f9d88293a97731bc58b944c6dbbb6de708276756b055a17dee44c3cc2244"
    sha256 x86_64_linux:  "4e1401e293f73a6c20331adf3e6377cf5fd1c3abb2d7e08740b009eac277f58e"
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
    url "https://raw.githubusercontent.com/ggml-org/ggml/refs/tags/v0.11.1/tests/test-backend-ops.cpp"
    sha256 "59877ef2a97114da23b0595ad3865960b43adecf153794c536621e4c40be538c"

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
