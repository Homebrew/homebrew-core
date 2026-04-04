class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.5.tgz"
  sha256 "f4c68ecaedfebf57e66a29681831046841cd9ab6aee668c01ae7fa6c23ec6eea"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c736fe3085623931af827f07d932de0767ed503d956fd497ab1a8054b194674"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7c2b121d3dea2ab70243a70ef59425f7da367eff322274f7a41a766619e55e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7c2b121d3dea2ab70243a70ef59425f7da367eff322274f7a41a766619e55e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cd87c88782605a536bef6c01c6bebdc0732ca127ae9d4b0a74cf4ffd66b52e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e18d63e225884b6b6b399ca8a7435ae85c2810fdeef782188eb2e7284b11920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e18d63e225884b6b6b399ca8a7435ae85c2810fdeef782188eb2e7284b11920"
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
