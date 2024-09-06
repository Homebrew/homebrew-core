class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3671",
      revision: "32b2ec88bc44b086f3807c739daf28a1613abde1"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c0db1ef980f5a0c99e01b8a684cee72605974692104f8f940be8b92e9a07c8d3"
    sha256 cellar: :any,                 arm64_ventura:  "fa9bd631fbbc4a50911043c595693983723a80a00a7b35eecc8aeb4351e1785c"
    sha256 cellar: :any,                 arm64_monterey: "3f25b8557b113abc649fd82a2bed870daa8c44813008da8ce803db04aae111c9"
    sha256 cellar: :any,                 sonoma:         "dc0795d9ff27e3c879e0119cfafdd78da0623d7bd1ec626096d33a91ac2c07fd"
    sha256 cellar: :any,                 ventura:        "43b21d3e2658485ef062742d2ca8c1440bb738fc528b3f4b6b52e2b967fc0dd1"
    sha256 cellar: :any,                 monterey:       "8180bf2e638f7f6e4ca3560ba9b8746ae0c587b26579a9f003d902e9af65360f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8e3c4d75277749896f12d4aba3c94349b692836bf8f3b32466ca3a633222797"
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
