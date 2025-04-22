class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b5160",
      revision: "66168204be9559dc841f06f0025f3da01d9a8546"
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
    sha256 cellar: :any,                 arm64_sequoia: "adccb1d7bf6e441f5e4c7c4fe65ac06bdcc7098de03bc7f33da099e6984a51ce"
    sha256 cellar: :any,                 arm64_sonoma:  "056bf3883db7d75b28338e8ef9f44f77e81f0e8080e6f57d047106dcfa6f169a"
    sha256 cellar: :any,                 arm64_ventura: "c58b9616b6d13b263a21c0d2e55c1a4fcf93e834b7f89708c813e142cc896859"
    sha256 cellar: :any,                 sonoma:        "c925cbd3f0f1a9e94575e48351b4991ac7513e68244b112121e3b56d82da2a7d"
    sha256 cellar: :any,                 ventura:       "e002a7a0f0c2aaf4a4c922aefdf7a5e93c63b37a82cbf3f7b93327d62ee754b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edd6ad1cbc77a7b7c85b2cc006b5b9885e0c8c967b014e9f0320564177c1a128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e398cbe4f00b0eac27e23bda61895c3ca71c6ba3fd52b253fd8146d062739480"
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
