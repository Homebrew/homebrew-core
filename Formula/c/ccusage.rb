class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-18.0.6.tgz"
  sha256 "e22673f301d8a5cf6acdd56433ef0fb366c4dbbc5fd071d77e993a9d8c76c661"
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
