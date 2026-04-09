class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.3.crate"
  sha256 "f6f2cb90b81f014b6438fe330238b5b2872a83d8937b3802a669fc55424d6710"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e4be417db04857035febd0ac1712ba0db51147fb2e67de414a71e2143551499"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29ae0ae0aacba34b9bd2ab8f5e987baf6e125fa980c6ba4b79b2d10b830d0aff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfbbe68022c123a4eb2b91347ee9ef31681a6f9844c36f01e5cc17fe261f522b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b9c33246cfcf28227b5a1ce18417818a799be83e808059d8583d1909aadd6c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "011f87374eb2808067e9132f8393c114f1f68d53584ac82a33e4b13c77b1ad76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df4ef0029b81d51cfa5f68f12615d54394ce913d89f5d5169d09c0662308c29b"
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
