class Jnv < Formula
  desc "Interactive JSON filter using jq"
  homepage "https://github.com/ynqa/jnv"
  url "https://github.com/ynqa/jnv/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "22423fe5d621848f2b7dd3b94511d74068b763235d07a30a191d086f6a98b6b5"
  license "MIT"
  head "https://github.com/ynqa/jnv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "272d9f011fb98188406a0d10efb323e2b8e4f800dd0d15070074e0d39ce4a671"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae8feccd4810098d6c84882fb8f3912706cf4f36979d7cfc1c0f2fe67ed5c54a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb8f91de5e610e09ba3a1de0625d977d432423372532828eb714fe17b3d9f960"
    sha256 cellar: :any_skip_relocation, sonoma:        "edf64bce1912b31ae9fc2218351b1b3cafda3432cffcc7088400ac8ef6d22c03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ed01cb4c627230047d2505596e9c54a610811d2c5cc9e37d55d86fd133a4117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e233d3a3c0c1f53a06155449293815381ff8fc0ff6f0f0c486a5c4d0e600a2c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jnv --version")

    output = pipe_output("#{bin}/jnv 2>&1", "homebrew", 1)
    expected_output = if OS.mac?
      "Error: The cursor position could not be read within a normal duration"
    else
      "Error: No such device or address"
    end
    assert_match expected_output, output
  end
end
