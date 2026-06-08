class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.13.tgz"
  sha256 "73c6a96bac36d0b954b48902bbdcde030c25dd687e6a4e5048d1460425b15775"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b9426e0b584a75e510092165a17de92c1a0cb714e41186842f030378549522f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0821ac0edce09cd930fd14cb33412da9689ad5610da06caee1c1728302423f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0821ac0edce09cd930fd14cb33412da9689ad5610da06caee1c1728302423f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b058276679ac5ed79e58d9ef6b2edbe77d58e5b2cb23d97538cd1eda8e8fa493"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bea5b6178f60bae7a7e3e3e5806a1dd5c03cd126dfab804e25d5d55e3126760e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bea5b6178f60bae7a7e3e3e5806a1dd5c03cd126dfab804e25d5d55e3126760e"
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
