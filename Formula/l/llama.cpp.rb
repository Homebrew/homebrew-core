class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b5650",
      revision: "09cf2c7c655c90e53e100f29b830a788bab0653d"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

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
    sha256 cellar: :any,                 arm64_sequoia: "1d1de1606125202f9582691bbdd659f01a856099d663f2b659c0ee01cf312548"
    sha256 cellar: :any,                 arm64_sonoma:  "ba9e22acaaca5ed1c70bd030a12c87024980c4e6cced1c40bc2e630f41d8bf01"
    sha256 cellar: :any,                 arm64_ventura: "ea448da0e510020c15788de598f58b364e2bc7df76b5a634ec69759a4b7ecc90"
    sha256 cellar: :any,                 sonoma:        "059330914e3072ba5d6a0274bf20558c0eed9ce5bb33fd12dad5ce3afe303095"
    sha256 cellar: :any,                 ventura:       "0363382717b310f682e2136dd5e3b611275c2db3e71a346782bf962bfa9cb4d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a47509dda50ea60bdf287a6e967155b2c00e73ca2d3bcebc2f4a9c1ed88fef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e620c7f47fcb4df9dd1825ae047b946c217ab91f443d38557d355868bf4b6f5c"
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
      -DGGML_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
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
