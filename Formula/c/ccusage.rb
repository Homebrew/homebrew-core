class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-17.0.2.tgz"
  sha256 "4d6b810ce15eb4ccfcd1316271f29927dd0007747fc00806e9f7b380e06ecfe7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "30c98198e089b55f0ac8531f95fbd796486f9ae0e25299a972ed3e2399985f4c"
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
