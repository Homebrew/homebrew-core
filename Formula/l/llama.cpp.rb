class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b8560",
      revision: "5c1a7b83550b4f1e0954007556f9b28f7db1a427"
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
    sha256 cellar: :any,                 arm64_tahoe:   "16914814796a8750604a26b277dd538adab8cdd4549fcc7bca56ee020e4c87bd"
    sha256 cellar: :any,                 arm64_sequoia: "b4e68fa7ffad77d20bbbf1bbfc18f0147f990d5ff8db88d098a379fd29029376"
    sha256 cellar: :any,                 arm64_sonoma:  "fd48f6b88b57954bb02372b08ae20364a79be2be5f0cdb1efbe06790d126c9db"
    sha256 cellar: :any,                 sonoma:        "176acbb1d9f003974f8c31484ca8eee8134777fffe4f50e6f0f65a7b1d7e0090"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "283ede07b0672a7257571e8307f59a74525a439389cc3f8f7297c69385d15d27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fedb981131338d54692286fde02f64ddf0dbf737bbf99798729d270ffe50251"
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
