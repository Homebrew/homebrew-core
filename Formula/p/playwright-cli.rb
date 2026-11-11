class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.24.tgz"
  sha256 "3423d619cb25c9666f835ef5e9c9d3aad5a1969594f554e563460ff3d65d43ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c1a82dc47820ae966ae602ac3fed5e60ea63dd874d85dc95494b203326efcd5d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/playwright-cli --version")
    assert_match "no browsers", shell_output("#{bin}/playwright-cli list")
  end
end
