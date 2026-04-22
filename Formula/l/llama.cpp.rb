class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggml-org/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "b8880",
      revision: "2799d933b5b5a0a54b151ea213f4c12c73b15866"
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
    sha256 cellar: :any,                 arm64_tahoe:   "af3bcd5a96d548b2cc9f71da169a2d378714d5e4a4051b7355d0f9fb76fc6eca"
    sha256 cellar: :any,                 arm64_sequoia: "57cc45655c59616d357ef30c4f1c419a3506ba950e7c615e3c56ac9b9d0ac62f"
    sha256 cellar: :any,                 arm64_sonoma:  "3bbad6bb3b97f9dda26dd957dba6da95fd029169f1a6bf9e43e745679bdc8d7d"
    sha256 cellar: :any,                 sonoma:        "5147fc496c54c90a31df8b3daef938493bfc9a6b6c74413b0bf9ddf47fa5c404"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9983814efdc4075f0c3a30e862ff21fa2cc320882935a5c66701d8a35e16152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2259007a290b8560699facf7c555121627e029fea10347c7e85bfe4198ffd8f"
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
