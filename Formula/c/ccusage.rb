class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-17.1.6.tgz"
  sha256 "efad648c84514aaba59cf7fc15a11771b38555f3e091e3a464a3e6ad28549c77"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a4ff8804362c4cdd319ecf7624ff1694c0dbe81bcf129918c3ea19e63a13b7a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "No valid Claude data directories found.", shell_output("#{bin}/ccusage 2>&1", 1)
  end
end
