class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://llama.app"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "v1.1.0",
      revision: "171527522610996f5f0acf12334e185156ca8f44"
  license "MIT"
  version_scheme 1
  compatibility_version 2
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "244cbb998d636f6f5132625b64262bfb4972634d30cb0b7c4a61904100a9e985"
    sha256 cellar: :any, arm64_golden_gate: "1d1affb8441ab4280d31de8a8a59c41d1fd04105a3545a24e934b202e67c5ecc"
    sha256 cellar: :any, arm64_tahoe:       "82568a466bc10bbbb65e920d8ed5c158b085d912d88f761f3f333317446a137e"
    sha256 cellar: :any, arm64_sequoia:     "b8f276158ee703b8c396889d06ec1b68e591ce61ab9f87a248ed450dbe5bc8b2"
    sha256 cellar: :any, arm64_linux:       "a0482a9cd028f322deb7dca14abfe08e76b602f14b4f008e6cd0837dd4351e91"
    sha256 cellar: :any, x86_64_linux:      "a1c36d62450f2891b2942bdd091a68bdb8d880cb605a83c77d75459460c1017a"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "node" => :build
  depends_on "ggml"
  depends_on "openssl@4"

  # `test do` block downloads a model from Hugging Face
  allow_network_access! :test

  def fetch
    cd "ui/apps/chat" do
      system "npm", "install", *std_npm_args(prefix: false)
    end
  end

  def install
    odie("we do not want to bundle ggml") if deps.none? { |f| f.name == "ggml" }
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_BUILD_TESTS=OFF
      -DLLAMA_OPENSSL=ON
      -DLLAMA_USE_SYSTEM_GGML=ON
      -DLLAMA_BUILD_UI=ON
      -DLLAMA_USE_PREBUILT_UI=OFF
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
