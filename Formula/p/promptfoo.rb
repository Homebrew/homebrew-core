class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.119.9.tgz"
  sha256 "3d16dd0c00a8acc47cb3f6177c487639df9355e69dd1abb2946ece9660240e1d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec1d1fa21322e1e5823644e99bca3308e265d003e5c9a6516ffc02479a69cfbd"
    sha256 cellar: :any,                 arm64_sequoia: "b7b69a0ba671bbb6f523da0a1f17fdf937302d4d3ba9ae279f2318e9e7656c24"
    sha256 cellar: :any,                 arm64_sonoma:  "c069fc14416aa1afa78d5e3ffb6c12695feff07345c9a3a5c4b0287bf9023128"
    sha256 cellar: :any,                 sonoma:        "5ee06ea38dc812a82c3204b5386de9f2755c8f285c93d58115b14e2821c4d707"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53041a635f75a41943884ea685e57ffc8f0c3756156df6237482176dcabae3a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05490fcfba5a96ca12b0f4fe3cf6b9b77391c6e3a14e248ac425d3a21e01f13f"
  end

  depends_on "node@24"

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
