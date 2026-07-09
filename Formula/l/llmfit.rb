class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.38.crate"
  sha256 "8b93ca394193ea268c19e27a300a309210a16b38311a457958bc6ee6b2024521"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "812c0c9f06999805083077eda974cee8a16529ed1f21e469fab8db2e4908fd7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a042f0ba5b5f3b79de4ba919e851172d0a7d5d0a28417634db89d014c10f9f3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97a3ad852852d925cc5d93faf126f762b82291e6e1b3d25a8013d7f1b706e969"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bf94ff3aebdcb523fb921e068390b5906f88c9519990fcfdf529a0c67f84c58"
    sha256 cellar: :any,                 arm64_linux:   "faf71370b2309a05dcf5eacf70d808b790d4b046608b16e3c0cfe6219417ab98"
    sha256 cellar: :any,                 x86_64_linux:  "c7a7397671eb6e23e849ca95b607e329275ceb275a83aba2b3991d7c0756b039"
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
