class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-1.1.10.crate"
  sha256 "5dffed80aa8930ce1d2ca342295f0e0ad3125489f9acc8af2455c22395000a3b"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fc84dee7285da49acc46e7650ebc3ebda18b177695be57034a6dd49c78cc60e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac0a0d298821736ee3e7fabf212b76070cbeca94aab74dabffba3798da01352e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7407c794924697408eb9a43903d0617507b3a418e01ec815be3961b0c7f3f26"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b30e9cf20450182fd382595bbba865126883b74dd0e04c04a458c465844c5a6"
    sha256 cellar: :any,                 arm64_linux:   "384f2bb4c12fee967921501c54ac1a47f7daee40b00c4b2324684d7075592966"
    sha256 cellar: :any,                 x86_64_linux:  "2e6fb331b583900e5e14d16a6aa88e08656a08cb1eec0f9e92f49ac3a734e6cd"
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
