class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3728",
      revision: "5af118efdaf1098798a06b24fd8a557760e99631"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4a82a1384b758bf3fe1e67959e5033a0c6d43e14343bcc2487362d65bf4719a6"
    sha256 cellar: :any,                 arm64_ventura:  "72cc5a4103401d048e45c7c985fab4423dd1bf14e230cf2c3e706472ecbffa2a"
    sha256 cellar: :any,                 arm64_monterey: "a338270ae0c3246dd425455b18a39a1d8c187e1f064d6647405b7aed834bd9da"
    sha256 cellar: :any,                 sonoma:         "82f488df12dbf9937e9245afff71d5f72c0b82dced6f1831ca2f05a7d17161d4"
    sha256 cellar: :any,                 ventura:        "f0de12980781a3939d04daf0e1b7d40e55229ecce8c6bec8fe69e7b81b140e09"
    sha256 cellar: :any,                 monterey:       "015e789eaa5a543eed687757423868d441d55733721d60d1b2171eacd986d4f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f498df9c18ea288861c073afa15e27efdfb4f3f3530667438f927c2941067d78"
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
