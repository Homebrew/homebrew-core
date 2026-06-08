class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.30.crate"
  sha256 "9194cf0cf6e648bdc59edafea036a502da64e6a831f1de949777fa19cc32a278"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ced042442ef0754bd9429e1420bcb7beab32809112d2e8d6a58fb48d20fb96be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2798029c32d5482bb76b0fa296cdcd1d1df7c26799fbcf4991958a08eeeabe27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab49fd8483ec755569647b9392a868d64f0cc42d006d18aecf220756f2b4532e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1798dcdde096f114ef2dbc52aa315473fddbec142181bd1e3fbb6a66093530a7"
    sha256 cellar: :any,                 arm64_linux:   "1d53b730c6144fc3180e8dd94bde1b912b42372c7a33d851708364cf6a9aa18e"
    sha256 cellar: :any,                 x86_64_linux:  "e85ef382248bdaf0600249bb5a6da393276de03b1accf877029d2cdc9005c0da"
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
