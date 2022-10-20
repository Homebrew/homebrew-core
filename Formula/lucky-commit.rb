class LuckyCommit < Formula
  desc "Customize your git commit hashes!"
  homepage "https://github.com/not-an-aardvark/lucky-commit"
  url "https://github.com/not-an-aardvark/lucky-commit/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "3b35472c90d36f8276bddab3e75713e4dcd99c2a7abc3e412a9acd52e0fbcf81"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d09b8c8990932d835c997abaedd007136627d5f2a0d708620fd8fecd8702ec70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06ba55d31250dfaf342d2f9a4e37158555844b1949e6fe2abad7220fb64be8ff"
    sha256 cellar: :any_skip_relocation, monterey:       "c47445b77ad8843994438d5bee1ea191029159fca8c019619fa586eff2caddbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "a016f90b4168d4ac97bb303ae86fecbb27b873a7677134537bd44509c6f96573"
    sha256 cellar: :any_skip_relocation, catalina:       "a54c93a1164be44359e8626cfdd8ce6ac07e7f0e78c8b53d4618593b20c5026b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4ead90e0bb96f4df966b4222db8e4a7543636a8f2ced16666f86c662f8f12de"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "ocl-icd"
    depends_on "pocl"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    touch "foo"
    system "git", "add", "foo"
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"
    system "git", "commit", "-m", "Initial commit"
    system bin/"lucky_commit", "1010101"
    assert_equal "1010101", Utils.git_short_head
  end
end
