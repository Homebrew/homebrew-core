class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3437",
      revision: "e093dd238282a980d248db0786063f8174400f70"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "48f678127272007c6121b44d541e23622c3fe55c33c7e722b7fce71b0e48c5de"
    sha256 cellar: :any,                 arm64_ventura:  "25a4160b37073a208e3ed39240ce3fe902361db136f354d8a05dba8e015e32c5"
    sha256 cellar: :any,                 arm64_monterey: "ee30d6249101ea2f1c5752928007f3423755d74fcddcfe1b3cb97850a6337b63"
    sha256 cellar: :any,                 sonoma:         "e6608975d9976c0236aa5884489e270bf665be70b0925f6dc954486c1505bb33"
    sha256 cellar: :any,                 ventura:        "5d2727ce2c39c704d0a4ab0af16dd8badd23de28d02ae59df22730d9ddad1025"
    sha256 cellar: :any,                 monterey:       "40fb5057c44133da9ec9d474e8ab9d8112735b6d6bfbea7cd28709bf591604a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f009f33698880937dd74be8ffab10df056a80c420d3d957a8ff48f347b1da52"
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
    system bin/"llama-cli", "--hf-repo", "ggml-org/tiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end
