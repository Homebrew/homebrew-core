class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b9070",
      revision: "f3e8d149ce174d615cbf6b96a83314ba6e00bd0c"
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
    sha256 cellar: :any,                 arm64_tahoe:   "7d9a3eb47b46accff1306b90f3aeb1fcad329cd51b5da13041316c0835d6fc59"
    sha256 cellar: :any,                 arm64_sequoia: "a66610d54902b4aef6e8a042c4ee260b7098fbef2f08ac8439f672ea80eb2ad4"
    sha256 cellar: :any,                 arm64_sonoma:  "d5588e789a5a8db206a406e181fb9402c865a209c938f2781c6408d10a3da02d"
    sha256 cellar: :any,                 sonoma:        "cbb631cb875575a9ff9ef9882249208ca9d0d7242653663fcb96648a1288cf57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2389cd448dca3f9fd43ac96cbdf363ebb72f0a9aa7e63451dea509c3b33820ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35847ad1bf01ef88033a3a294b9f2629bc0033ff41ad70fb28d57a137c2022e6"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ggml" # NOTE: reject all PRs that try to bundle ggml
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
