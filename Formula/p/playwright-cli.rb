class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.14.tgz"
  sha256 "3b53eb91f610a66610e4dec7589e9f9135a1f77378ce79714a3605bcb8313e8a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fa7a8edddf4c0f1925c3404ad6c5282ea8358e0dce7566c995aafcae061900c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7db816eb91dc3a2d0ff60ef218fbbe9466492c31a7e93dbc10517f5717b76af0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7db816eb91dc3a2d0ff60ef218fbbe9466492c31a7e93dbc10517f5717b76af0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c79a2cff19db54a810b21a70354dd1aa1d1022713b3b86bf4dc585c8570817f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4a63d77f2bfd917045edf7972bcd5ee5281dde6e0bb2205361aef45f90e8928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4a63d77f2bfd917045edf7972bcd5ee5281dde6e0bb2205361aef45f90e8928"
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
