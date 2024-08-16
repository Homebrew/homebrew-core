class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3592",
      revision: "2a24c8caa6d10a7263ca317fa7cb64f0edc72aae"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "89d85c46bccfd0538d3dde1ce54397118f4f9cc5befffd4592b73d490bf76ddc"
    sha256 cellar: :any,                 arm64_ventura:  "6cc84d645dffe09a170fa2f1e47f0943de6ba135324ea5f8c0b8cc207806b661"
    sha256 cellar: :any,                 arm64_monterey: "669372cd4d90ec421587a5ca86cca9e0dca433a79d5c6f59c632056eeba3b425"
    sha256 cellar: :any,                 sonoma:         "5a3e5bb6e642ee6bd41023e85a49f58952a939aa0c99ed54c4ea2afae7e46d4b"
    sha256 cellar: :any,                 ventura:        "807f766109efd972d235a5fee5ed85ef8e22ed9341d300e1e33ddb56493189b8"
    sha256 cellar: :any,                 monterey:       "724c3ed607f5b0e0dd0bb7315706a537d966acb4436880743fac23a58634c23c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7633aee036ef2c803d6a25e77f17870eff6400e5b6f2b49a5ff38f832e577ed8"
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
