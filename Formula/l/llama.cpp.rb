class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b5190",
      revision: "558a764713468f26f5a163d25a22100c9a04a48f"
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
    sha256 cellar: :any,                 arm64_sequoia: "4b8fc4f43253daef9499c61f67c0fa8a36e7d5165ccc8ace31d2ab21cd15fc97"
    sha256 cellar: :any,                 arm64_sonoma:  "3bbf5cc88d313b2f3f5829d2f9cdd8fed1379e076a9f4d074fa4a799a7273326"
    sha256 cellar: :any,                 arm64_ventura: "ceecc9c0b8e4e2ad32b4d5f84d24e1d2ee991fba83fe3006b12b1d6bffde07cc"
    sha256 cellar: :any,                 sonoma:        "2a38f1a83b7e899c456beb38b6231d9da6874e59853c357b8d4d05ac88db60ad"
    sha256 cellar: :any,                 ventura:       "f616084ee07d3defd805aa4a35603624ed0cb20dbd77d17c1e053efa00f2688b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2f1a7a832f7e722d37f07b005c29d07cd48abc6947f2daf611919e50aefd714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e479c26ebb2eb9c408a524bebd8d2efe677d8f3293c29c7015c770890939f313"
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
