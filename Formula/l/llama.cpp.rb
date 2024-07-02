class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3282",
      revision: "968967376dc2c018d29f897c4883d335bbf384fb"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4ed4e94331172adffd83c197b791396acb2e99b1e05122a5154714f50fc96772"
    sha256 cellar: :any,                 arm64_ventura:  "b47ad751fcd52161d8782825ba20035de848f8d648d1677d10c01ba3d813af7b"
    sha256 cellar: :any,                 arm64_monterey: "00d45ef98befdff5c0dd56939ad5f386dcba84a05097cc14eeae6c34de6f3ef7"
    sha256 cellar: :any,                 sonoma:         "1e4f733720ab840fa53c0f49684fc90166675d1cd743f03fdb587b8a297b357f"
    sha256 cellar: :any,                 ventura:        "4ac0e5fef33d57b61f325a9e4c5064b848585ec635cb8e13082521570e6d985d"
    sha256 cellar: :any,                 monterey:       "e07a6989675dfa04771e5195881719da8b2340a4e255fcfa0c488ad132638c32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7365e74626ee1a129a9f7b55d6c8a6269046525f0c8dc93343f8ae880008a4c"
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
