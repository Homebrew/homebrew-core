class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3604",
      revision: "1b6ff90ff8301d9fe2027be2bb9fea26177d775e"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4445d4dcd02ec1ef5ae88b277a3e1a2ad7f5288985e3f192135c26658af84e00"
    sha256 cellar: :any,                 arm64_ventura:  "58a76a7c33ca5c392b3bd6414f2080bdd068782bc75b17e749d96477f164f872"
    sha256 cellar: :any,                 arm64_monterey: "28e84c96959f8ae30d5bc678f9024419a3c4be3d90aab4197d5b97e7f910b977"
    sha256 cellar: :any,                 sonoma:         "026f1c326d19e5a9e9c26635bf2c3a145bf28494f3b03c7d71d68e1a27bb4586"
    sha256 cellar: :any,                 ventura:        "81a6369a348c5527ca5367221dce83355e6552687f77c5e3e59757f33c41afa3"
    sha256 cellar: :any,                 monterey:       "4d3156c9320299f35d2d52a336314d37410fe68d689c3e5656269332f0a1ef14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c8fd17c09ec98d89ed3f67d2e9893f25b23f3b073b447bdfc8e90e396acb7d4"
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
