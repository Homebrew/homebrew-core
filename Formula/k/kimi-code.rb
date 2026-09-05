class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.40.1.tgz"
  sha256 "dd6dd058384a500a08bc9d3982a8e04eb248c69403869dd16bd20353ef75e5c3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ae96e6233077bc08a597a17b6a184057d8fb6830d24036ed7520d142078eb7f4"
    sha256 cellar: :any,                 arm64_sequoia: "ae96e6233077bc08a597a17b6a184057d8fb6830d24036ed7520d142078eb7f4"
    sha256 cellar: :any,                 arm64_sonoma:  "ae96e6233077bc08a597a17b6a184057d8fb6830d24036ed7520d142078eb7f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b7c1816c467b424c4384260603a9b0f6381d7f4cd78f2f1cb16d86aab03e588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c03b44fa915f904246c9c863ea8f6bb5d3420f7c8583fab1d28e37f17598dac2"
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
