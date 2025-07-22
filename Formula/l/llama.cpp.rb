class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b5960",
      revision: "c8ade30036139e32108fee53d8b7164dbfda4bee"
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
    sha256 cellar: :any,                 arm64_sequoia: "dc5e79a061ebd819bb15dc47e701b5391e8a8e3fb878a92f19455beeaf1e0fc1"
    sha256 cellar: :any,                 arm64_sonoma:  "6cc130b209f7a153cd725fdff6e9404641ec264915ea34d3a0ae9e1d440fc8fb"
    sha256 cellar: :any,                 arm64_ventura: "4ddf12bd55d17b286c947dbd811135632449dc72fe02408245774c0fae472552"
    sha256 cellar: :any,                 sonoma:        "d5893426fb5832c5c3bc21d08c7118260a319ad782224c0f0c33bc7317fadf42"
    sha256 cellar: :any,                 ventura:       "edbc618bdfc787237d381b5b7c285d1947cfa0ac0333c9fe9d930f3ba88cf7a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2f4b13685f46fee176d8280f7fc74a886a7ef0d6208f60abea82530897a3e91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cbada2df8f7f09786aa25bfe80d9b1a5d03187c8974c3c734a368598d7baf87"
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
