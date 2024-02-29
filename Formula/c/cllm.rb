class Cllm < Formula
  desc "Empower your CLI experience with a command search tool driven by LLM magic!"
  homepage "https://github.com/dev-backpack/cllm"
  url "https://github.com/dev-backpack/cllm/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "2f0713c46b9e977e80f0263c7030a60899c4c4020049e2c02b2157844d299103"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/cllm", "--help"
  end
end
