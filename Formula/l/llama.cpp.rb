class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b6070",
      revision: "15e92fd33791e60a4ddb5970b47242a855c27117"
  license "MIT"
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

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
    sha256 cellar: :any,                 arm64_sequoia: "5b59aeee5c60b2f6ebba75cb771a40d8603460607fcab2051d99f031a34023e5"
    sha256 cellar: :any,                 arm64_sonoma:  "7accc6e63bab142ace6d7d6f48d7dfdb341e0ba7a8c84282ec0669e8db7f8d2a"
    sha256 cellar: :any,                 arm64_ventura: "a8f88e3ffa8a4dbf60df3aa04aa0c45c91bc8ca6facec8601d87b017f63d26cd"
    sha256 cellar: :any,                 sonoma:        "5df69d24a78991a98d66047218dce358a29f0f5d713f1d93ac71fe20868b3386"
    sha256 cellar: :any,                 ventura:       "fc8db10e5a4b6f09e3abf4ad45bd94f0fe0d21351de45d070cf57f840593f4c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec7c4bfcb13ee31e2ecbea88332fccfa116e1c45f549f376c711e68d9a29e660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db86b7990bc5e3c460c4793cf3f0c9b787d0d1562cb7202c9bd5bf94af4d89f8"
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
      -DGGML_ACCELERATE=#{OS.mac? ? "ON" : "OFF"}
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
