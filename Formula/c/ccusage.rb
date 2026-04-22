class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-18.0.11.tgz"
  sha256 "6253658b2176efcc66734f19665c31d0c6b8148c3f36d6d72ec15d16871b55a4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f54ff325f54908173cb24d7442068e67c47435899982c39c7959605bf0f13cbc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "No valid Claude data directories found.", shell_output("#{bin}/ccusage 2>&1", 1)
  end
end
