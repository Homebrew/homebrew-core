class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b5940",
      revision: "83f5872404baa39d826af2ef66351e63c64205a8"
  license "MIT"
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `trottle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b5d0c1e5444608a190529f88b7cac6e98c0ca634db424e0988947ccd2d477152"
    sha256 cellar: :any,                 arm64_sonoma:  "84cc130ee06938ff17fb1cb3a94648300fabf8a4c4ca23b7dfa4febcbc76c846"
    sha256 cellar: :any,                 arm64_ventura: "f7bc90356576f59818c54a877ae8644f695b86df768265006b291a6720c201d0"
    sha256 cellar: :any,                 sonoma:        "9367cda1c4bbb73fa04b68c51bb9a9964cd609bcebd442ecd5a648d83564ddd7"
    sha256 cellar: :any,                 ventura:       "36afb79968320a7985c944fedcff986db309a26c7686363f9291502408163b8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4e631b3887e7f81e08b5dc7e1dc6f0ade856221087e73f86df38524ef0ef205"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c32edfddbd1280718759f2548a366a0dd6c7e0a7d7e2d36eaa48848bbf15e48"
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
