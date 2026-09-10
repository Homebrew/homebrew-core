class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.42.0.tgz"
  sha256 "686f888cfe7ef888159ffeb760bcdce9f4816e8b7fe9962529e59251b0ac3372"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16a1d8333124a68230eaf0be7a5518acd36520b6dae3af7997030bfdd893182c"
    sha256 cellar: :any,                 arm64_sequoia: "16a1d8333124a68230eaf0be7a5518acd36520b6dae3af7997030bfdd893182c"
    sha256 cellar: :any,                 arm64_sonoma:  "16a1d8333124a68230eaf0be7a5518acd36520b6dae3af7997030bfdd893182c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf88da5678b316d19f238c5ca6e569ff882ed5d39b95ceb506747091222e2ce1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1b7f4e6c521d89f88953287978b141a4b9b3bbac555ec85c0df58ca75dfc3da"
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
