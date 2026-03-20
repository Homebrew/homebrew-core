class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b8420",
      revision: "7f2cbd9a4df77a2ce10f31d69f07d4fb75eabc07"
  license "MIT"
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
    sha256 cellar: :any,                 arm64_tahoe:   "efea4e33511bcaa7eef561a2d158f57ebf3d7f54de103c7b1af83eabc62378ae"
    sha256 cellar: :any,                 arm64_sequoia: "e2f81ad233b137e38f41e734156a7d0a45f5f84e627f1a02dc7d6963eeecd1c5"
    sha256 cellar: :any,                 arm64_sonoma:  "3b09467ca77bf2552dc6d1b34ec579fe0e34652d1666adbe29a5dfdde5fbc5c5"
    sha256 cellar: :any,                 sonoma:        "94761e846a89d02c3a4df55695033922a64785fec1f61422e1376c5c727417b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6461d40968aafbe321f41b4c7e164e758a402bcdeef39424e8678de4cf467db0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddb05534a0c676e71ff431e0b4732c65abac2e4cd27658d46bc14de44df1b379"
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
