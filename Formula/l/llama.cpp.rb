class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3483",
      revision: "4c676c85e59ef8f771f3a129e6eb217552139231"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6153a78fa63d386e8b79cc9cf62332e11cc08c895e31b641edf62e68918f392d"
    sha256 cellar: :any,                 arm64_ventura:  "9b481d8d002c807eccd5636f3cbfa1ff56f97341453f4b4dac2286f409787c6c"
    sha256 cellar: :any,                 arm64_monterey: "bdfae3e08b3fc8d48f8a3618553910b9dcbd28660cb17ca09770d4bedd129aa5"
    sha256 cellar: :any,                 sonoma:         "2ffd7eb37508880f4fb79d34c1e816e58976ff22ce6f594eb5447284e47b933e"
    sha256 cellar: :any,                 ventura:        "eb6b81709d25385795c7d4d3fd8b90a1e8615bb9fd788e8cebc0164c677ac6fa"
    sha256 cellar: :any,                 monterey:       "5849d391461bea2b58d9b3abfed63fedcd283a10eca17aa89160756f57dc0cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c4775f16f9eee22e399ecda8905fd79070e94560fa87278be22e259f0bad995"
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
    system bin/"llama-cli", "--hf-repo", "ggml-org/tiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end
