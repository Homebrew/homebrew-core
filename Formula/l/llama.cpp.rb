class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b5560",
      revision: "c04621711a893cbd09cff6c927cb005bc6749e36"
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
    sha256 cellar: :any,                 arm64_sequoia: "04c88af5e39ab2348e2d1987ee6b168ca2ee8bb5aac3fc739b58455a8f07faf2"
    sha256 cellar: :any,                 arm64_sonoma:  "a8cff9db6099fe4218c4a1e8c9c32914308bed1d3d0f883f82b8023e91d74eaf"
    sha256 cellar: :any,                 arm64_ventura: "1cca9a380dafa215bf4af2b08ef09fe0bf5dc3d9ef6d6c436bbf09a9594fa419"
    sha256 cellar: :any,                 sonoma:        "c3157ad3def1f91ded7c877c7fe4749e6ec4d6a7581f6a5690a8a63ea933adb4"
    sha256 cellar: :any,                 ventura:       "c74331af1fe90305a86b76c3ac3718c16622b444ac2c154072fbd33118f6d5b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ee9003a20f2e32c1df06b43178c68de0edef07994638a109d5274948888c9b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d46851f20a3eaca5dc9501fa0106e4bf902197d18d749140f0e39e3e80f48055"
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
