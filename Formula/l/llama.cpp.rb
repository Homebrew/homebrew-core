class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3509",
      revision: "ecf6b7f23e664afd7ff856ec39034240ce438daa"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cd23973a355af94e94af469833b912857d43227471199077db02206008cc69ed"
    sha256 cellar: :any,                 arm64_ventura:  "6c5d5e4a990a3a3a8a22dd193c0e95facbd04d506da71950a7591b75fdd6e028"
    sha256 cellar: :any,                 arm64_monterey: "bc5a81a1fc1e48f811e06fe0eb2b6062e87d02cc336c1739fb5e7a81f2ebf326"
    sha256 cellar: :any,                 sonoma:         "2e6b6839180351900eac2bc6a4e65c1f1fb07bc5e55025fd267862ce699d68a7"
    sha256 cellar: :any,                 ventura:        "dcc460d17a6cc19bb24b67de60bb66d160d839519974670dccc282a6fab51f4d"
    sha256 cellar: :any,                 monterey:       "2716e3ced71559617bcd23e69e038934092502e91746970d6ce5fe7ca71325b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ccce4303a5f86292acf8c196cc002cca89e37f9902c7c46955e3815683aa801"
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
