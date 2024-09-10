class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3720",
      revision: "00ba2ff78100e187ae17987bacd1c916211718b2"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c238acd026d0ac0a760cc25c5dfde4d7d762f4c61e3fa54b68782722bf648819"
    sha256 cellar: :any,                 arm64_ventura:  "8bd139412201bb66fda961d386ce137462c1369c8c22ce6620053db18b45e92f"
    sha256 cellar: :any,                 arm64_monterey: "8aff1f6c1f991d4c6804e008e235485e7c7462154ad7f0ede608ce04c8857898"
    sha256 cellar: :any,                 sonoma:         "5eedbc4e10a8a160f30f88a7be8f1dce600cc51fd5ee50aa404be72a1aebc656"
    sha256 cellar: :any,                 ventura:        "ac3e7ce0dc409e7448bc9685858bbc876bca0c7732368f926c3aa269dc3b0c49"
    sha256 cellar: :any,                 monterey:       "55656b2cc3697d2bfde73a12c8a1495eea2c56ce2a03ae2e47caacbd69cce53f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7b5933d481033242b2e50a9633e5363e336db0d6c5e20cdc781a86c5c0a153a"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openblas"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DLLAMA_LTO=ON
      -DLLAMA_CCACHE=OFF
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_BLAS=#{OS.linux? ? "ON" : "OFF"}
      -DLLAMA_BLAS_VENDOR=OpenBLAS
      -DLLAMA_METAL=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_METAL_EMBED_LIBRARY=ON
      -DLLAMA_CURL=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
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
