class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://static.crates.io/crates/llmfit/llmfit-0.8.4.crate"
  sha256 "93dac11633e8dcbaa8e3a91c9bf0b342c0d206295e360b5a37d6588360f1f69d"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52c8463f146e539583ae9da968f65b4cf23dcd73405d2004bb1b76540670e8bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5fa356e126c7d6dc05b9215b3b52ecf7b5efb5e3d93729f5c65c7286d0a6798"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccf52008e619ef1a0370c03b55aca4fe2909ae5cbbf936a85a44c7b425097e78"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dd011578a256470d9456be68b8597d98fe8b5979ec8ddd15b61e40a4cb4f8e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa4b29ab2f79ea84d42aba19dfd82c27f485b2de56e624a7be9fa79a2f6708f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c619465b9e6ddacd71bb5bd0d9e6f3c2fc2f93c727fb9127da6a18b41f6ddb72"
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
