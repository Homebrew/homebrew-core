class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3656",
      revision: "f771d064a95d212ddadea452ad0cc1e42b2c3db3"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f2ced8de93fab30a34abc0441ad6f12c8d17cdcc78892474c943337d9dd24709"
    sha256 cellar: :any,                 arm64_ventura:  "2e9ba1490683fb1b633cf3613280fce1ff711f47fe96540ba8648083f25dcbc2"
    sha256 cellar: :any,                 arm64_monterey: "1b9fd80c0e3b3ce83b32d00da053672093ba7b98cfa0f4a5c4d20284249219d0"
    sha256 cellar: :any,                 sonoma:         "a660040ff6f0582988d768b8c9738a94a2e2151bee4d5130e448a8ebaaf752d6"
    sha256 cellar: :any,                 ventura:        "54964628c1573467a920ee4fe00f5b81ab20ebc3d24040931ad4d34e41bb5abb"
    sha256 cellar: :any,                 monterey:       "9d1b40abdc44476e0e2ab56e20472393c85c4b8c77203deb520d5c2f96a2045f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c1f7a6ad330514b5c9ea249042261c8b14a5939e895f7cc86b2bf51945c362e"
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
