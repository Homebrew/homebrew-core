class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://llama.app"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "v0.2.0",
      revision: "bb4caa7540188872173c44d161602d9271386413"
  license "MIT"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b70f377b407c18b71b6268cb182042df851b49a401dd616a3c265ab16b7adfdc"
    sha256 cellar: :any, arm64_sequoia: "957991b7caebb41c647bb129ecdbcadb0ce28ac9a5c70cc8144e5970ee5ac433"
    sha256 cellar: :any, arm64_sonoma:  "ecfaac74306b550ae4bbcabea15f6dee7fe43afaa612c4d3b422796521a0623f"
    sha256 cellar: :any, sonoma:        "3fd7d6728c776f01353f6f9026464f31911d665f04d9bb942230a03243b44992"
    sha256 cellar: :any, arm64_linux:   "9e79a68f2fa34300ce25dc54892d6668e5459a6f83f3f41c2cdc4527db1f2766"
    sha256 cellar: :any, x86_64_linux:  "9929ab4380464bd5907969906bbe0a556eb58d31501c0da4ecb66e661dea43f8"
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
    args << "-DLLAMA_BUILD_IS_DEV=OFF" if build.stable?

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

    assert_match "Available commands", shell_output("#{bin}/llama 2>&1")

    # The test below is flaky on slower hardware.
    return if OS.mac? && Hardware::CPU.intel? && MacOS.version <= :monterey

    system bin/"llama-completion", "--hf-repo", "ggml-org/tiny-llamas",
                                   "-m", "stories260K.gguf",
                                   "-n", "400", "-p", "I", "-ngl", "0"
  end
end
