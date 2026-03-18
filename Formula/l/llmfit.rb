class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "e8935e174d9751fa0babaddea996b113d3d44086d6b1be193fd3e4d191e42197"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fa3730f0bf61026d2ec983d60558b07689c9aa42ab75932d89ba77180c78263"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ccdea8f230f88e104d9c157b90502b6d2b8f176befabfe88d84c239321c6568"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "937a721d70dc0084ed5cfb37b342a1741894ed090f0671799ad2d9f7c2b73054"
    sha256 cellar: :any_skip_relocation, sonoma:        "757dae3c24274e3532a3a9f4aca13cea9e6dbe5a5771a4beffc1ca71ba98ca1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "034fe5277b050f1eafc74898f41ad330e236e5dd8bca0acabb84e9c852431f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ea7684843f2da57af86554d6ecc3bc6a68af225656d178816960fda2eabed31"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "llmfit-tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models match", shell_output("#{bin}/llmfit info llama")
  end
end
