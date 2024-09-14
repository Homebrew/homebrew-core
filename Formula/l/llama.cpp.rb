class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3753",
      revision: "1f4111e540bacec8d00ca9fd96417bf4c1339394"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "648423994d72e3bf2465fd544b77d1bc141825b842d4d24eef44620ab1a539ea"
    sha256 cellar: :any,                 arm64_sonoma:  "19e68f701d72444115fca3db719c4dfbb88c18d56d43435217b00951b4b200fe"
    sha256 cellar: :any,                 arm64_ventura: "e63b261eed05930315c5a3cfdf220088db0fdd0154ec487b743e7f43091019cc"
    sha256 cellar: :any,                 sonoma:        "96f0088de220d036cc0e2e5c68b4e5f9df2615e70092287b2685d54094ec3b0d"
    sha256 cellar: :any,                 ventura:       "1fbf06620e82c941d805b90e0cc7cbd2dad916549cbc4367a494b36a4890b0fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bb9e3cca151b71f48781887e036329bb97bcbdc67bb10bbde129ca0e673b044"
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
