class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.119.8.tgz"
  sha256 "7db72cfeebc7cb999dea4b064dbaaca1d79c8ec311c70f2e201737a8c230aaf5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "67de3ef2ceb95e3e642c468f96f5a2fa43222ea3b307868a356622dc90962936"
    sha256 cellar: :any,                 arm64_sequoia: "61fa9242e9303d156f9265311ff4dcb25f063615bfd153ca3e74e0c6141a9cda"
    sha256 cellar: :any,                 arm64_sonoma:  "b7e2c0e9880533e073e14889ed676dc265f45472735e44f62f1ad768d4018c2c"
    sha256 cellar: :any,                 sonoma:        "9d586c0561ebd51af133a59f88b5f31b329c6af2caa29e1d7863adb38f737763"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "693c8315b28c47b824f51b40c8389f07b44a7ded29dd037ac6f9c683cfbe3d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23bc9433af15a126006ac4c3a490ae8c5cdcf40d54a12304ce5746c0b3cda949"
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
