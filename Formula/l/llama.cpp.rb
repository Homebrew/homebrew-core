class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://llama.app"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "v0.9.0",
      revision: "cd959bae99ff4bed22bef2604f45241c09bbb8c8"
  license "MIT"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "16f24a06c5a05a81bd56516628ad377d3352fcc90bd5fde2285831132c8d7f5e"
    sha256 cellar: :any, arm64_tahoe:       "a620e51b63c8ccd5594c74df5006a9ee46425d13a5a94afb8922a565a4e3d9c2"
    sha256 cellar: :any, arm64_sequoia:     "b1bcd0ce334419a139582fd998e05abc98d90f28c696e2a07381152deaeff82e"
    sha256 cellar: :any, arm64_linux:       "fc00dbdf6443f7f95753e0d56229e60414ce892d4b2711355e266d66722c6ea9"
    sha256 cellar: :any, x86_64_linux:      "7e276690384f390b42a6ea8f5729ce16d253b877aaad5e83821c0818367772ff"
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
