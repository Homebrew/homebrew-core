class Cllm < Formula
  desc "Empower your CLI experience with a command search tool driven by LLM magic!"
  homepage "https://github.com/dev-backpack/cllm"
  url "https://github.com/dev-backpack/cllm/releases/download/v0.1.1/cllm-x86_64-apple-darwin.tar.gz"
  version "0.1.1"
  sha256 "bed0845aa5a4f9fc6c5bf3eb8c7d6ef77201c753ce6a4daf74f70e41f1cde47e"
  license "MIT"

  def install
    bin.install "cllm"
  end

  test do
    system "#{bin}/cllm", "--help"
  end
end
