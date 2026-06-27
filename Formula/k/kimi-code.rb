class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.20.0.tgz"
  sha256 "46a9e18dff82d08bec7f5210ced5b5e6d3760279694a8ee50d6ce96adeb8bf08"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f9754df6d7d5e48e93d20b414d7796446c3af0f13f68d28fea3349a6632ba7ea"
    sha256 cellar: :any,                 arm64_sequoia: "8a422846b38b39125adda0e1f5c0dfb6590d5030d97a3d3e173168dad4c1f27d"
    sha256 cellar: :any,                 arm64_sonoma:  "8a422846b38b39125adda0e1f5c0dfb6590d5030d97a3d3e173168dad4c1f27d"
    sha256 cellar: :any,                 sonoma:        "baed8ffb4e458b9f5e63e4227058c5e3047e67a3728dca6c7479a144d27fff88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28e35bb45341f8de6715f4d386bb653bac59097a6a04157ce759ea9aee1635be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5495e54265e2e46f7ac296dea763983f090c739bf8f1ad21f4646f57ea92adff"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    node_modules = libexec/"lib/node_modules/@moonshot-ai/kimi-code/node_modules"

    # Remove non-native architecture binaries from `koffi` and `node-pty`
    if OS.mac?
      other_arch = Hardware::CPU.arm? ? "x64" : "arm64"
      rm_r node_modules/"koffi/build/koffi/darwin_#{other_arch}"
      rm_r node_modules/"node-pty/prebuilds/darwin-#{other_arch}"
    elsif OS.linux?
      # koffi requires libc++ which is not available in Homebrew Linux;
      # remove all prebuilt native binaries to avoid audit/linkage failures
      rm_r node_modules/"koffi/build"
    end

    # Strip universal binary to native architecture for `clipboard`
    if OS.mac?
      deuniversalize_machos "#{node_modules}/@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kimi --version")
    assert_match "No providers configured", shell_output("#{bin}/kimi provider list")
    assert_match "No model configured", shell_output("#{bin}/kimi --prompt hello 2>&1", 1)
  end
end
