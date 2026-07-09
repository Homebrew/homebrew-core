class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.15.tgz"
  sha256 "6527cb669d7500de63a8a5c4a371d51ba296b0434d6ded43e1b9c02a1ed03cb2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afc4a1e8d96dd7df6b293166a47fe60063d7628374cd912ffd4dfc7bd2af592a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6a852a510962e89827622f5a753ab3d78bd7115a4be776587328c8de4590534"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6a852a510962e89827622f5a753ab3d78bd7115a4be776587328c8de4590534"
    sha256 cellar: :any_skip_relocation, sonoma:        "950771d4abd1431df18dd05065be0fdc42248013bc2b478847da4e8ca86953d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "135a5b1203bdad061f8f4567aa967889c4ceba770bdde3094aea87ef5d2f3e0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "135a5b1203bdad061f8f4567aa967889c4ceba770bdde3094aea87ef5d2f3e0c"
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
