class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-18.0.5.tgz"
  sha256 "0a8f7e8c50e4e1699e7eb0e726f95a7638d893e5c785860428d29bf4c6eb914f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "78852b0a6ad33a32c580714ab6e16eec3ebac07ad4d6e520300eebd6b64c3eaf"
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
