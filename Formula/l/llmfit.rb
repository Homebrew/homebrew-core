class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.15.crate"
  sha256 "4bb3da6c0c0e6dbc6b15a6e464a37750bb55883fa518b96387de51595762f632"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7b53f42c4421cad2055d83b762970934f82497f08041fc4efb606e8e8f5af20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c3db951a007a4ad758eb3a1975d8040e4e3b745be12d90e80fca742af84618f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cee0de0b7e48d689784f00832e83ff84133c08c4be6752ce7981e622e9a1870e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b1d47a7a0cc49b2d5ba2c4cc2d934700ddd5d0d31e99f0dc569b93c32a0a1f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d361a4b98f161d23a9fe71182a12bdb3e5a15afb7e24346d644570580dc9734e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4ac16fc68dce04b5e7432ab45e7a92658ebe667294ccbcd75fd8acff074284c"
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
