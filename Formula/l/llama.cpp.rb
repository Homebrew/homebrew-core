class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://llama.app"
  # CMake uses Git to generate version information.
  url "https://github.com/ggml-org/llama.cpp.git",
      tag:      "v1.0.0",
      revision: "b1b770d90d94cad9e9ea5b993bdbc383a522fb28"
  license "MIT"
  version_scheme 1
  compatibility_version 2
  head "https://github.com/ggml-org/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "40798097079b338b08065bada929ef6a502a2d20b1ab20b30dd60471e6bbede9"
    sha256 cellar: :any, arm64_tahoe:       "71eae02656f51a3b0ecad8649a63f09551574d812c88325d1517b24bb54dd74b"
    sha256 cellar: :any, arm64_sequoia:     "8f3a536136dbc5080749aa9cffa1a64e0d83160dadd89ef3f5d67ca06adc8d72"
    sha256 cellar: :any, arm64_linux:       "92cd950b34e36361ec24dca1aa933645f6c72584a2b8f36467f01c6cd13f0235"
    sha256 cellar: :any, x86_64_linux:      "3dc54f7e37858c5e9dd4478bc3548c19e1317997fe9d5a6898f7cf6be2c89424"
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
