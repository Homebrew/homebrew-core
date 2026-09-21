class Checkpwn < Formula
  desc "Check Have I Been Pwned and see if it's time for you to change passwords"
  homepage "https://github.com/brycx/checkpwn"
  url "https://static.crates.io/crates/checkpwn/checkpwn-0.6.2.crate"
  sha256 "ab3ba2a2fe867307ae05121d24eef96527b25ca1ca8ef10d808b24e2e51c271e"
  license "MIT"
  head "https://github.com/brycx/checkpwn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4d50ca7a08012847eb110945a91cc2dcbd79fc15c693e5101181405c716ae7a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "694011d3bb43326d542b06174a33275fde6eb7ab023854fa3835ded88c0ba5ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a8e72c9e4834aaf47aba49711d419167ed305a7f0993f38e459eeab3aa5eff08"
    sha256 cellar: :any,                 arm64_linux:       "86d730294b35b3f7d2e27ad36c46d4c83d5237af6ea98024220002b0033b2491"
    sha256 cellar: :any,                 x86_64_linux:      "c4623c95d50367b3a5871d27b04b1718a0258f0c66ba975cca4f156e2e996a32"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/checkpwn acc test@example.com 2>&1", 101)
    assert_match "Failed to read or parse the configuration file 'checkpwn.yml'", output
  end
end
