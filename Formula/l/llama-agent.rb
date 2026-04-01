class LlamaAgent < Formula
  desc "Local AI coding agent powered by llama.cpp"
  homepage "https://github.com/gary149/llama-agent"
  url "https://github.com/gary149/llama-agent.git",
      tag:      "b8745",
      revision: "b13b1d14041757387f9454339049578daa21b8cc"
  license "MIT"
  head "https://github.com/gary149/llama-agent.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=OFF
      -DLLAMA_BUILD_EXAMPLES=OFF
      -DLLAMA_BUILD_TESTS=OFF
      -DLLAMA_BUILD_TOOLS=ON
      -DLLAMA_BUILD_SERVER=ON
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_OPENSSL=ON
    ]

    # Prevent picking up system-installed ggml/llama headers from Homebrew
    ENV["CMAKE_IGNORE_PREFIX_PATH"] = HOMEBREW_PREFIX.to_s

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"

    bin.install "build/bin/llama-agent"
  end

  test do
    assert_match "--prompt", shell_output("#{bin}/llama-agent --help 2>&1")
  end
end
