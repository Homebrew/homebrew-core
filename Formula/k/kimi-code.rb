class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.23.1.tgz"
  sha256 "56bd8cac4cabf06a160901b8fe6bfff534df56c6879ae05f7637aea01c2bc98f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d8a544744493753cbc5df2056a0e321b14891d92449808b85e2f66f50605f0a5"
    sha256 cellar: :any,                 arm64_sequoia: "a2625c7f13857be1dc7caaacc54a8331d3b27aa3da66869608e86761fdaaa64a"
    sha256 cellar: :any,                 arm64_sonoma:  "a2625c7f13857be1dc7caaacc54a8331d3b27aa3da66869608e86761fdaaa64a"
    sha256 cellar: :any,                 sonoma:        "8f4870a48faef2fdafa60e65b41e897cf2e46e1da34dce85daf43119e0f4d546"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b841c670337566bd9b09c1cb9c57b19adf02d7f0bea9320498f510497a791ec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e62e220a4770c313cf0885a517090e7b767e9e8ec741addd30fa001d13291bc5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    if OS.mac?
      kimi_code_prefix = libexec/"lib/node_modules/@moonshot-ai/kimi-code"
      node_modules = kimi_code_prefix/"node_modules"

      # Remove non-native architecture binaries from `node-pty` and `native`
      other_arch = Hardware::CPU.arm? ? "x64" : "arm64"
      rm_r node_modules/"node-pty/prebuilds/darwin-#{other_arch}"
      rm_r kimi_code_prefix/"native/darwin/prebuilds/darwin-#{other_arch}"

      # Strip universal binary to native architecture for `clipboard`
      deuniversalize_machos "#{node_modules}/@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kimi --version")
    assert_match "No providers configured", shell_output("#{bin}/kimi provider list")
    assert_match "No model configured", shell_output("#{bin}/kimi --prompt hello 2>&1", 1)
  end
end
