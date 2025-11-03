class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.119.2.tgz"
  sha256 "32579fd9a8e6c6e1b1c4975aa117cd8be7730b5635603b3fe15cf8de6a5d468f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a05988533b1ad0143c764b430565766255984ee1c6a20d30381695ddfeda57ec"
    sha256 cellar: :any,                 arm64_sequoia: "6382be8e86c7564dd0ed35eb3d4e17cd88e334b7f1e137b51343dd9f988946e5"
    sha256 cellar: :any,                 arm64_sonoma:  "48028a09403f36ff7f73e5072e1854ca45dafdb2c693886891dc1d60eb937206"
    sha256 cellar: :any,                 sonoma:        "acebd8706186a99169634db24edd0a07f3a5686ce40b7593ab626a538cd661e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5dace8f3b669d678ad812411a724f7654b9407e7c5ef9ab9be8e3ea400c00cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17b392f892b66ff34e1edb0c405201eed28769e2383768288f006a72f587c1d2"
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
