class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3617",
      revision: "a07c32ea54850c989f0ef6989da5b955b77b7172"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7f1ac3d4d26df4cc8ccd29e22a418e92c9d2ff3e988cf75070e9e69596cb176b"
    sha256 cellar: :any,                 arm64_ventura:  "9465b33cb6cd94031ffea54fb3d19d0247dd78bf996d42d3835dd9930f5bdd76"
    sha256 cellar: :any,                 arm64_monterey: "586b4dd6efee90a56ddcaff91754437c94ff1c06f417eb64eb15fecf7e9535f9"
    sha256 cellar: :any,                 sonoma:         "ac34b67a5881d09fea359694230a66ee75c7e7cd61baa580061aa5e0fbcb93ea"
    sha256 cellar: :any,                 ventura:        "3e209b3a5fca922ff2d25203d2ec84e6b18ad58f2fd63bb03239ecaddd0b4c74"
    sha256 cellar: :any,                 monterey:       "b1fcf19f13cb3397efdd5f4d94f8e3b322b5395eec32a24d3d3df6309f2f0e2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d287444deaeaed2ad061ef7fa0cfacdad7eb0eee6b46a184e87e093b9b133853"
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
