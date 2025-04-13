class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b5120",
      revision: "e8a62631b3b05bcf2ad0e0c686881a9f3e3f03ca"
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
    sha256 cellar: :any,                 arm64_sequoia: "ad2b9898bdfb6a7ca6ffbcd2ca560d8708d0ca3e9b633d14c3189e4572893117"
    sha256 cellar: :any,                 arm64_sonoma:  "c3cbdc3875f13d0653474c277b3a202fa38d4a4cb5cd70c632c02534982a232d"
    sha256 cellar: :any,                 arm64_ventura: "c6765d44e10957c40bef028f3a6aad22d8877c1f73f41e92cb578123cc41d3ed"
    sha256 cellar: :any,                 sonoma:        "88681576d80529b51f5ce2367f6490055ed8aad0bb048df0b3ccecea8bea1ba2"
    sha256 cellar: :any,                 ventura:       "cc16e9a0919d12125317fb5c7fde931df8eab9c2d5920e4ea87c4e6cf510a1dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "097437d9b9ec878858b9221593392e68b7816e526533cea261b96c9e888a488c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea83aa753003573d68c0954b92f67fa2f3f2b81046b34ac1b875c2f24a3dda3c"
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
