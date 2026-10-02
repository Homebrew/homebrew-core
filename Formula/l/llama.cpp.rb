class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://llama.app"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "v0.5.0",
      revision: "7fe450e19305b828c199d602c23a8337aaa1f03b"
  license "MIT"
  version_scheme 1
  compatibility_version 1
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "edf032b5a3a73bc47c94849bde12f877322b98dbe36d6cf149e24ce4db14b234"
    sha256 cellar: :any, arm64_tahoe:       "1dea72a74612d3fab141d92220c8c4e5746cd25fede74636fdec8b915845d605"
    sha256 cellar: :any, arm64_sequoia:     "b611092f4ec89b8268e10f360665b98e46f90ed64941594fb658da1674fcbd5b"
    sha256 cellar: :any, arm64_linux:       "f9c4b954bd49b80bd60a14480504420155308138c8ce9ab7f9d1ffeb7525f523"
    sha256 cellar: :any, x86_64_linux:      "9557f45d82abec9cbf64b80f1ccfded618cec11fceed42ee1a3684badd6c01b2"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ggml"
  depends_on "openssl@3"

  resource "ui" do
    url "https://github.com/ggml-org/llama.cpp/releases/download/b11146/llama-b11146-ui.tar.gz"
    version "b11146"
    sha256 "832be73b1d077980b047ddd2212f8a8a229f7c007a03ce032ea06448734ea6f2"

    livecheck do
      url "https://github.com/ggml-org/llama.cpp/releases/download/v#{LATEST_VERSION}/nightly-tag.txt"
      regex(/^(b\d+)$/i)
      strategy :page_match
    end
  end

  # `test do` block downloads a model from Hugging Face
  allow_network_access! :test

  def install
    odie("we do not want to bundle ggml") if deps.map(&:to_formula).none? { |f| f.name == "ggml" }
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_BUILD_TESTS=OFF
      -DLLAMA_OPENSSL=ON
      -DLLAMA_USE_SYSTEM_GGML=ON
    ]
    args << "-DLLAMA_BUILD_IS_DEV=OFF" if build.stable?

    (buildpath/"tools/ui/dist").install resource("ui")

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
