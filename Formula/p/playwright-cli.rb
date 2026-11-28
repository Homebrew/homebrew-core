class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.25.tgz"
  sha256 "4559e4674cb5d10a03e0c15e9f5c892dcfa4f5d8703c49146594b4af322480f4"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "17a8fd3f6c2782915186084bdf1a3e1f870ea7b5e222184465e09da8ca50598d"
    sha256 cellar: :any_skip_relocation, all: "868f9223260959d68b259b4054a2638079a22048e008d62fedca171c7f23b104"
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
