class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3163",
      revision: "43b35e38ba371f9a7faa6dca4c5d1e8f698ffd87"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fcd5753af5810cf1ecdf9c486ff7d5e4de7c225e5e80515c82ae6111de69d3c7"
    sha256 cellar: :any,                 arm64_ventura:  "503f66e3f49b490fa0d77856aba39290481ae39bb657fa3f513f69c1014d6106"
    sha256 cellar: :any,                 arm64_monterey: "c9aee656bfabc8883f7db4ea7cf660ad489cdf8ccf9c7e198da2ea2d3bde2526"
    sha256 cellar: :any,                 sonoma:         "4a4a44c76995e7850138d6fca77ec0fa1cc8393e31485f46c058bae27351b063"
    sha256 cellar: :any,                 ventura:        "6bc0811b55ed4b08c86de01a4695e3816a2b4137fb6c1665833fe6f75a7d6ee1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3ae48ab9aedaeb40d4f0a6e03b0dd65c1e1e3e9c88346138458348383185932"
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
