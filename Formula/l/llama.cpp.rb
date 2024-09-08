class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3705",
      revision: "3f7ccfd649abc83d059b5462221ac14de4ede6b7"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b602590d313dd21083bc633041d04410bc75a7e6234a73587cfd3228c0f75a8a"
    sha256 cellar: :any,                 arm64_ventura:  "c403f52b65025cfa2d1c0f8a4cf0a270cd0469961bb76eb796984930ee5489d7"
    sha256 cellar: :any,                 arm64_monterey: "d23f0f3c18048de1a8c317012d66c4da8258facab672ec7015598a3fe471562e"
    sha256 cellar: :any,                 sonoma:         "3e72342e0153083ebd22ceda6b0adb63165de3ae0c580d2e43159ec806180eca"
    sha256 cellar: :any,                 ventura:        "40b6f0b36e956e380d4cadeb1fbb7ebad3b0f42767ca6e284af5eb83a2641341"
    sha256 cellar: :any,                 monterey:       "13c5697b662afb805152e2d5ba9cc21b04d1014b6005eb207c2f93a76888e4cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31a521e45b628f62c75d8125364140c7142c99daab4771f21df7d97f34ac33b7"
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
