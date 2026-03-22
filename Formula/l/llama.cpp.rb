class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b8460",
      revision: "b1c70e2e5419ced91eec570b9aabc050afe185e1"
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
    sha256 cellar: :any,                 arm64_tahoe:   "eef29a4b09a607eddcdf3ed705db08eb00a9951ee607fb7c55cd2a107bc06cf6"
    sha256 cellar: :any,                 arm64_sequoia: "f8f58e375fc7ce0f21af9ea0a7f08b9b41391dc46e61ee805c930508ae5a67b2"
    sha256 cellar: :any,                 arm64_sonoma:  "8a357b2e43fdb5c552f5b1dab899809b23fbcdf2a8f4f4a826c87e395562f22a"
    sha256 cellar: :any,                 sonoma:        "dc4da5ac5a15b3eccd06113be84861b2685b9a490c3ba1b964685f8a574c93d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "929012547f04d066c17aee4d8af309d33ad1ba3959fbf922005a4c7e851081e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82e7870395450c3518cc05ef51f829e2720d2e4fe84f469ea53717006e6751a7"
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
