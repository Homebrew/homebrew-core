class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-1.1.16.crate"
  sha256 "f3d331c1169e6e6cdd1a9d6d807a623690bce8142c1d3bd1ffa72487e01c637a"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b8e3abe2e5d5f02347da4effdacb363b59cbb0ff2c8a176371a01d0c1d31b143"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "343b24e32a7f7e3c3b922b2c76f556af4d28bf0764cc0b265700883c834d6374"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2ff9cd8897f88e7eba956a9d29ce85f5436a90e9471e55cc7a7aa242bf5da9a9"
    sha256 cellar: :any,                 arm64_linux:       "2d491541de553d2264076e7d0c6c2802d376368fb12bbc460d365e26d335b209"
    sha256 cellar: :any,                 x86_64_linux:      "2da55ba734fb60484c349d7af89223fc5fe1e64d3091b2e041f5982c48f04a6c"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match(/Found \d+ model\(s\)/i, shell_output("#{bin}/llmfit search llama"))
  end
end
