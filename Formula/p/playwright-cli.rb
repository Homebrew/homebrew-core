class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.7.tgz"
  sha256 "a5c3558a18db9a55bb2815cf0506c6e998ec1757e049ed0d2eacd150897a4363"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0b7f9407f797d28d7e80587e67b4f4858a22494d6bee4bd16a73defce9390c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51b79dcc0542954b304c1ca679a729b54186e31ad9915ed25db1ffa3d20b1f10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51b79dcc0542954b304c1ca679a729b54186e31ad9915ed25db1ffa3d20b1f10"
    sha256 cellar: :any_skip_relocation, sonoma:        "265d6e349284ce4a61d7831da303431ebffe3ef5cf082f3e4e4526ab85241c19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79150e367e3f335866f775f247b59181284300298fc70adfa5536398dcdc33f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79150e367e3f335866f775f247b59181284300298fc70adfa5536398dcdc33f2"
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
