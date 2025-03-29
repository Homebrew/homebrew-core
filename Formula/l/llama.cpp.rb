class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b4990",
      revision: "a69f8463510a70fe0c85701b8c7ede283a0d1a7d"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

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
    sha256 cellar: :any,                 arm64_sequoia: "ddc50de00b4e753aad4d1f80974f6ed037c4620f851d070949ea56a50c04d451"
    sha256 cellar: :any,                 arm64_sonoma:  "203e3d23c8db361d9307f32c69491abd12da3a6252fb2d41d67ec2ecd24e26ca"
    sha256 cellar: :any,                 arm64_ventura: "506ff655673b54d507d88b901ee6f44fb39c289912610a3a37edc4feaf992f67"
    sha256 cellar: :any,                 sonoma:        "e82574b83fd5f88f239efc933a782140617bf7eacd2d8d132d4300a82255ec0f"
    sha256 cellar: :any,                 ventura:       "013186308655369df6f8d9bf0c0db4389797be1cf771470daec103b5538044f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9358cd1060674f642240e6af8c96a7042d6b6421ebf6ffff82b9c43a97c34072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e0ffce54ddbbde09b818131414b6ef2d53d91cdad2b95b69d30565711accff7"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "pkgconf" => :build
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
