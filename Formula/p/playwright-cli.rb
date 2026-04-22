class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.8.tgz"
  sha256 "ed42526772b0ce7f777b86f6c00701fe3f5ae55ba980e511e1fd2eb37d4f7da4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bb8617c41658a321592d5fccb17465edeb56bdabe4cd0c5ee24f8c90a2f0b72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3596cc9d97d06210a5216322c6420af3c951753f735b5b483e3587eeaf324dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3596cc9d97d06210a5216322c6420af3c951753f735b5b483e3587eeaf324dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "daf8f21cd7b76654a97a6a46d1fe7aa53b3fd3863f46827053d90f94aa6744d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b84b8202a45c20a1c497423ca5e0f6bd5d710c5468e9362fef4c5261fe64cf03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b84b8202a45c20a1c497423ca5e0f6bd5d710c5468e9362fef4c5261fe64cf03"
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
