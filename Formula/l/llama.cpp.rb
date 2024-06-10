class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3091",
      revision: "2b3389677a833cee0880226533a1768b1a9508d2"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b6bbce2e9faed7eca2b345a496314477f027aba63887486af42bca373ecddac1"
    sha256 cellar: :any,                 arm64_ventura:  "ce53a39d4551ee0d0e5dadc03fe3717b0cdcd6d707bdeb7c6bd73313f1bf48ad"
    sha256 cellar: :any,                 arm64_monterey: "fcfb48e4ea12264665db61359149a45509d33bea0313fcb5972c9179e4fe2587"
    sha256 cellar: :any,                 sonoma:         "803d5910182346663fe4ba5656db46506d01c843e3c9fcfafbd65583425029c8"
    sha256 cellar: :any,                 ventura:        "941389be59c2e32ed1f158dc61b5f050faecb34cab2509e306e4fd2efcb814d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "691f180de67e1942885e62245c1cf09eb492a24c535467607265c3a7bad2bb01"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
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
    libexec.children.each do |file|
      next unless file.executable?

      new_name = if file.basename.to_s == "main"
        "llama"
      else
        "llama-#{file.basename}"
      end

      bin.install_symlink file => new_name
    end
  end

  test do
    system bin/"llama", "--hf-repo", "ggml-org/tiny-llamas",
                        "-m", "stories260K.gguf",
                        "-n", "400", "-p", "I", "-ngl", "0"
  end
end
