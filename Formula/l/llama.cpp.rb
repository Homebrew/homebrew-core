class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3848",
      revision: "c919d5db39c8a7fcb64737f008e4b105ee0acd20"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4d5968ed29898c01a46bdcc69bd3dfddf125628fff57b6e0be66228a99e4fa8a"
    sha256 cellar: :any,                 arm64_sonoma:  "8196a3a5fd0155b9bc4b9f426703c4742a42635bc9aa1e72d27566e80204beaa"
    sha256 cellar: :any,                 arm64_ventura: "d7e483e5b034c082d573b48cba66e41775416a38ed2933459554f6b45bbe7d6b"
    sha256 cellar: :any,                 sonoma:        "1e9b975c27b770bf39a476ad9ebf8c98a40743d92ef4c495116f8df93376c680"
    sha256 cellar: :any,                 ventura:       "8ff8397aaa11973cfc9c31ffa706107d7a40046f5f42340b8880b20b37d5102a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "936e6b66098ead78d2134db9b3dd432f8980f760cacb61b7e7e72ecc50cf76dd"
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
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DGGML_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DGGML_ALL_WARNINGS=OFF
      -DGGML_BLAS=ON
      -DGGML_BLAS_VENDOR=#{OS.mac? ? "Apple" : "OpenBLAS"}
      -DGGML_CCACHE=OFF
      -DGGML_LTO=ON
      -DGGML_METAL=#{OS.mac? ? "ON" : "OFF"}
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
