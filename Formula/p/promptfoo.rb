class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.118.17.tgz"
  sha256 "3c8b18b2e84c676e6ffc65c50b57143559439be02dc595025cbdbde714273125"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e2430ac0fd4526ead87c99272678c341907c1e27711792f63c3362d6ad162eff"
    sha256 cellar: :any,                 arm64_sequoia: "7eba8acf274664bbde337d715ca0dfa4fc2261c21a0b522b6df8c656ca7a6f23"
    sha256 cellar: :any,                 arm64_sonoma:  "4e84f8d7e044c323e3aa8b2f1acdc67c4fd4ec7d7766568edffdaa8c2ac677e2"
    sha256 cellar: :any,                 sonoma:        "9975061165c42464b18bc77b42f09252ce154ea1c4f48b6907d7b0f49835d8b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddea07610443ed1b60317546cff4a07f63c1bae45acb4bb92268f52eb15a4393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1a44b98b5e5cc1df6a305586e2650858810d9cca205c586e672e4b115721d01"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/promptfoo/node_modules"
    ripgrep_vendor_dir = node_modules/"@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r(ripgrep_vendor_dir)
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
