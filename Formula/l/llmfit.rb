class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.9.23.crate"
  sha256 "0bf5ba7f9980ca8b033296b11ac1fa1dbf5dc5ab8e1721709f31d134d519bbd3"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8f8f63eb831b1ff92aa7d8aa2c077fe66a8a508508450232584ee3b2bb6e6a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6111cfb6f25b0065230c09832382a96c19f21106e0aa2113b689ce78cc86a47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94d749dc002cad9c58bc30338afb6ca0c11396f31e35d478d6e58ee9c56372cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "08d93c32dce07adf6a00711a1f60d603b6d93260e69ccda2d52e52d689b0b608"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "739beb4bc6dea4c3d7a2a457cc1d3d9c796669014bcb60c1f2cf3f78ba6a3a1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04c5b25fff62c2cb76e00fd7fcea0a3d6b850c5d5e6be8bae237aa351947dd50"
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
