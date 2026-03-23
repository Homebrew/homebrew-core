class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b8480",
      revision: "07ff000551fffd99a4d481c1dc5b05abdbce7fb4"
  license "MIT"
  compatibility_version 1
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  # llama.cpp publishes new tags too often
  # Having multiple updates in one day is not very convenient
  # Update formula only after 10 new tags (1 update per ≈2 days)
  #
  # `throttle 10` doesn't work
  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*0)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b20c304613acf994d617a295483a1bf419f79b9c59c21c4bc892345a33573882"
    sha256 cellar: :any,                 arm64_sequoia: "5c29487d95de1de7f072dfab8f721b29a551b6aa7ceb069bdf9407d812e1ca8a"
    sha256 cellar: :any,                 arm64_sonoma:  "f4b3127423dad403ea30f0a3af2657fd07384d2e12ba3181651d767c0130183b"
    sha256 cellar: :any,                 sonoma:        "24140ab869b59d1efdba3e7db31ed1e03d45208f54afcab0801f1b9eab93311f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56de48f8e4c359701e0e0b7905db219099e2b7f2940a741bcff2fef68745462b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69142176a6e16f20b0e7c907a38800579d67a7540c7730b22cb99c9b775c7cd1"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ggml"
  depends_on "openssl@3"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_BUILD_TESTS=OFF
      -DLLAMA_OPENSSL=ON
      -DLLAMA_USE_SYSTEM_GGML=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "tests/test-sampling.cpp"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)
      find_package(llama REQUIRED)
      add_executable(test-sampling #{pkgshare}/test-sampling.cpp)
      target_link_libraries(test-sampling PRIVATE llama)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "./build/test-sampling"

    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin/"llama-completion", "--hf-repo", "ggml-org/tiny-llamas",
                                   "-m", "stories260K.gguf",
                                   "-n", "400", "-p", "I", "-ngl", "0"
  end
end
