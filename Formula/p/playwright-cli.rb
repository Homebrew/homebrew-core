class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.17.tgz"
  sha256 "1e00bf493d491231f7e106863b762d25c05cb30d9738059e68ad3252d28422a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e48239472a9c99e44b2f21053a3ef534e62b6562da300e4070540e383ee02a10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0e928c6950230b4672b0fcf1ca0a1d3d3ebe9d059cda6e861ab252b4caf1f44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0e928c6950230b4672b0fcf1ca0a1d3d3ebe9d059cda6e861ab252b4caf1f44"
    sha256 cellar: :any_skip_relocation, sonoma:        "793db36f27c8d62f949da478dcf4da0d36892aa8308e47e212d575d7126b4128"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf62662ed4774f4196ba1da34ab192ec8e742ac928b05076f981b1b86b8b5e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf62662ed4774f4196ba1da34ab192ec8e742ac928b05076f981b1b86b8b5e3f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@playwright/cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/playwright-cli --version")
    assert_match "no browsers", shell_output("#{bin}/playwright-cli list")
  end
end
