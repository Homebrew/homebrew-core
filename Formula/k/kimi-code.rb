class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.38.0.tgz"
  sha256 "d5c047dbfbbdfddf8d20030327e723ea9121af66260983a8556124580d64b549"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "619b520acd4799eba1959280865d6836c87fe01d53c2f32029dea746d0ad8ca7"
    sha256 cellar: :any,                 arm64_sequoia: "619b520acd4799eba1959280865d6836c87fe01d53c2f32029dea746d0ad8ca7"
    sha256 cellar: :any,                 arm64_sonoma:  "619b520acd4799eba1959280865d6836c87fe01d53c2f32029dea746d0ad8ca7"
    sha256 cellar: :any,                 sonoma:        "18099803ea826a1a3fd045c4f027c1b508c790cc2b1c7135cc5d57756190876a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e28fe04122dcb2184d75199c50faab79682ea28d5e7929cf1d27841326f3642d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fd37a13f4496b3de477ab7d15bd32604ba3de5396e7e6562db8e28335a9a240"
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
