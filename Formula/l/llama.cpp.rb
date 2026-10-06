class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://llama.app"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "v0.6.0",
      revision: "d81235049384534c167caea52b85a694f6103d14"
  license "MIT"
  revision 1
  version_scheme 1
  compatibility_version 1
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b02966242fd7fdfcda0070d79a5225c2a80f506ff7e74e9ab116eaac93387ecc"
    sha256 cellar: :any, arm64_tahoe:       "2030b868c907e097a1c622e5aae31a26da14cf4c074bbb8d124ea8091fc08e13"
    sha256 cellar: :any, arm64_sequoia:     "6c9bfc46a16bd87d929c5c3a7aea5614607434b3390d7b19d362b77e81ad6734"
    sha256 cellar: :any, arm64_linux:       "002a7a5def07120b79f0ca66dd44e2ed13c6fa1a15afdc82c3bf9daaf0a24154"
    sha256 cellar: :any, x86_64_linux:      "f6626a6f07eb1df925ceefe850a5b65419c3526000c75808abc4bdff2c4200ff"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "node" => :build
  depends_on "ggml"
  depends_on "openssl@4"

  # `test do` block downloads a model from Hugging Face
  allow_network_access! :test

  def fetch
    cd "tools/ui" do
      system "npm", "install", *std_npm_args(prefix: false)
    end
  end

  def install
    odie("we do not want to bundle ggml") if deps.map(&:to_formula).none? { |f| f.name == "ggml" }
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
