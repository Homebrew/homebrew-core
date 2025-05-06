class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b5280",
      revision: "27aa2595321c4d9cc4086a8e67bdea204b8309b0"
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
    sha256 cellar: :any,                 arm64_sequoia: "6892a8b2c657f9881e760e4166600b721d7d4076951583f1c37dc956396530fa"
    sha256 cellar: :any,                 arm64_sonoma:  "48c5dc67dbf57f940634d593f0c9a34b3928849d4f1e7a929953a0c2332539b8"
    sha256 cellar: :any,                 arm64_ventura: "38890d00922a7e681a9673377ae2783ab466910da6ba42d71bfa0aa037278936"
    sha256 cellar: :any,                 sonoma:        "471f2f686fdc4dcdb33c20b00083593369fafa36b466d832c61188c3848d6d00"
    sha256 cellar: :any,                 ventura:       "2848469a85359c42bb09f1d38e4f6442dd29a42a302d0470f279e9309859f96e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90300ec41959db9ebd6560b608539b2dc5714a385f33fbe312629c4bfd100ebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97ecba84fba831dd071a9aa971822ee3a0c38ec633087d358ea96ef9235632c6"
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
