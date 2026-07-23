class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.29.0.tgz"
  sha256 "f8318c51d60639da8841757dd246b08bf49bfdfac5d8dfd5cf2f625a05ff0104"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c1fd2f6e71b6b17e1d29f8cb5851f4678da65f66c8c9402bddbf926c3e6a7d60"
    sha256 cellar: :any,                 arm64_sequoia: "c1fd2f6e71b6b17e1d29f8cb5851f4678da65f66c8c9402bddbf926c3e6a7d60"
    sha256 cellar: :any,                 arm64_sonoma:  "c1fd2f6e71b6b17e1d29f8cb5851f4678da65f66c8c9402bddbf926c3e6a7d60"
    sha256 cellar: :any,                 sonoma:        "3b58ca0f5839ecc0d83935e76fcbd3d6cb85f1189cea2e35d89bfb61332825fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3c432adc4d9087bd4822a59a872478cf80c2174ce352bfd10f3b0a8af4d5bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c575d309dcd196a265bff0ad93fe41fbb29091409d6995bff0deca5113d060ce"
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
