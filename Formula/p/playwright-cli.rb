class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.23.tgz"
  sha256 "70a706ca63b053dba5e0103d0d96758aee20ed916fe8b32721f886c99d0ec2f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1065ed948f4b420fe5c962f968483bcad98c0e1b65d4073b935a3a05c79418d6"
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
