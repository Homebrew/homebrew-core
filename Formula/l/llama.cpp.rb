class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b4644",
      revision: "d774ab3acc4fee41fbed6dbfc192b57d5f79f34b"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a4ba7c8a6f5eb22574ed906e1370f07c0b1b9f02841285355f3d7a555a4b764e"
    sha256 cellar: :any,                 arm64_sonoma:  "84970f25d68b1097ebfa188ff82742ce0f6a8bf39da2caad2147906a035113b5"
    sha256 cellar: :any,                 arm64_ventura: "21b5ecfed9a637de1285d3cdf5b674ed1490ffe62be5d4fa53b8037b49c488e5"
    sha256 cellar: :any,                 sonoma:        "8c3dc8fc89a36ea4ac16f12eabd04cb3b8c7ee42bd3dfbfe120a1eecfac5a00a"
    sha256 cellar: :any,                 ventura:       "5ac2fcc8a811d75f2625d7b04d23280b0fbfedfc9e12682dcf15cca14ac71538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ac1be16b71e21f3a0c1cf9e8b8f48349c2a79f0f949582505d16c685202c561"
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
