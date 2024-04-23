class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  url "https://github.com/ggerganov/llama.cpp/archive/refs/tags/b2780.tar.gz"
  sha256 "8b1831b605ee4c564ff84e648dabdc11fe3d77dcb6b1d7e4d97a14ea991755f2"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    throttle 10
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    libexec.install "build/bin/default.metallib" if OS.mac?
    libexec.install "build/bin/finetune" => "llama-cpp-finetune"
    libexec.install "build/bin/main" => "llama-cpp"
    libexec.install "build/bin/perplexity" => "llama-cpp-perplexity"
    libexec.install "build/bin/quantize" => "llama-cpp-quantize"
    libexec.install "build/bin/server" => "llama-cpp-server"
    bin.write_exec_script(libexec.children)

    pkgshare.install "build/bin/test-sampling"
  end

  test do
    assert_match "Sampler queue mpk OK with n_vocab=10000 top_k=00100 top_p=0.800000 min_p=0.100000\nOK\n",
    shell_output("#{pkgshare}/test-sampling")
  end
end
