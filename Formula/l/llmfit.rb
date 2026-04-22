class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.11.crate"
  sha256 "be26df286b732cd6ce0f852e221d4b95bff297a6f8c4c8ecd45d900b2d747258"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7468a4775d5ad2e30ee2dfd063b4207582213ec6912d1b3601bc52574e9babe1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "222612db43a9cc16335cb1e5c1b05a9117d6e288f92f566aec236693adc4bb36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55d82198c6feb7ca84b8a51031efd0f0b9f5f906d020a2a605bb2c3d3eccd726"
    sha256 cellar: :any_skip_relocation, sonoma:        "b48384c5f82b48f2e08657ed807a02147af8136b632234fb42e31f85a40fd2a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bf5788605c07e1491101ac1b639ac320772b73ea2726fac18e60f962ef8b03d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8683676e4ff481ace0447fba27e9c97349180d7231c1ba2906fe2220bab8210b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models match", shell_output("#{bin}/llmfit info llama")
  end
end
