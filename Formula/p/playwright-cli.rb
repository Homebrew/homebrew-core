class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.9.tgz"
  sha256 "6be72037aa032f75349a9a1eecf67bae6120aeeb2855ea53adb30fbe6bd5931b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6374475d444afd20acf950dc066e2c2b933eb44443915f567059329ba2321972"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b203d919b8e46b716257d5241cd141cd7feb53b2fa611a626883b0551e7e996c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b203d919b8e46b716257d5241cd141cd7feb53b2fa611a626883b0551e7e996c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d4fdc81ee4de034796d198b9736a689b1112aeff92d14dd0509bd2a48262a1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fc7035b6c96c3790d274cc900f9ca1e3572053fb61dd16fada80c37f801471b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fc7035b6c96c3790d274cc900f9ca1e3572053fb61dd16fada80c37f801471b"
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
