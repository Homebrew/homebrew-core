class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6370",
      revision: "661ae31c9c68201577e70278285b349a5a662caf"
  license "MIT"
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `throttle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "551ce317f1753bc8591bac8846058840ce8ab2965faebbc8ae1649d3bbadb839"
    sha256 cellar: :any,                 arm64_sonoma:  "2c8f7aa0daab063d6685bf8aae412c7bc73e4c507bdb43e815ebc2ac9aa509ba"
    sha256 cellar: :any,                 arm64_ventura: "2e49abe9209f5c9c06fd2fcfce41942feb7b4fea2888154fdd96a89b8d01b1cf"
    sha256 cellar: :any,                 sonoma:        "9a97394c074ff2775d7edc12f1536957bcb7b8f9771c5c721fa58b30e4bc632f"
    sha256 cellar: :any,                 ventura:       "78095ffff5bce519b591307234a94fb5cf8b1e1cb40b96292942d87799132a52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ef84233b005121ad615ddb47b1a6eaf8f48616ec421aafdc53164bf7890d029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a0a88813913791b61f0b307e87553e7e59ec6df6af69c8905970ec6edb272a7"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "openblas"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DGGML_ACCELERATE=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_ALL_WARNINGS=OFF
      -DGGML_BLAS=ON
      -DGGML_BLAS_VENDOR=#{OS.mac? ? "Apple" : "OpenBLAS"}
      -DGGML_CCACHE=OFF
      -DGGML_LTO=ON
      -DGGML_METAL=#{(OS.mac? && !Hardware::CPU.intel?) ? "ON" : "OFF"}
      -DGGML_METAL_EMBED_LIBRARY=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_CURL=ON
    ]
    args << "-DLLAMA_METAL_MACOSX_VERSION_MIN=#{MacOS.version}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install bin.children
    bin.install_symlink libexec.children.select { |file|
                          file.executable? && !file.basename.to_s.start_with?("test-")
                        }
  end

  test do
    system libexec/"test-sampling"
    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin/"llama-cli", "--hf-repo", "ggml-org/tiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end
