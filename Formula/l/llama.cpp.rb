class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3763",
      revision: "c4965a64f72ac9434c21cf0e1c3421d13e889155"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "602c70f77debc9eaa2b5f69e396ad9add721c6cf746d237a5729ab622702f36e"
    sha256 cellar: :any,                 arm64_sonoma:  "9ea274ff3b49b788024c5a1b2ebb9704d93b0e28ae62b68ef0c959499b5d7aa6"
    sha256 cellar: :any,                 arm64_ventura: "020c493412cd4cc5b772a81406c617bbc8a5aff106d05f33bae78f36a4aff58a"
    sha256 cellar: :any,                 sonoma:        "c86d3d74d8557051b4e4f054c0785eecafaf625e5fb388bc00828b0c6249c473"
    sha256 cellar: :any,                 ventura:       "2c26ab605ee01086ef9d759c62f8aac2573a839602cc72b1cfb03136f59f97e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e41c6b85f25b66249e2cc824f0b50c8c57f34d8ea4a389aa91fc4f45be10f73"
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
