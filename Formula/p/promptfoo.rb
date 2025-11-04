class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.119.2.tgz"
  sha256 "32579fd9a8e6c6e1b1c4975aa117cd8be7730b5635603b3fe15cf8de6a5d468f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4f481e154dff6573c57ebef4d10cbf2b37d6c6f08965c01042fa6b66d0e3a986"
    sha256 cellar: :any,                 arm64_sequoia: "aeb5d5574eae99e874dd26727d8586c59adf2123b0de8e1280b6a707438ff756"
    sha256 cellar: :any,                 arm64_sonoma:  "81b8c7100ace23679ab39114b2ee498bde6b63f9fa4396917efe685979262b3c"
    sha256 cellar: :any,                 sonoma:        "50fb2ca69d79f47309e5ea85d7703ad0b246a02e3113bc249236de34cf89b6b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e5eba92b39ae5fb8e0615afb38a99551c85637ed6334cb1c03461baefc32a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "add4800562ee18412b2c432ccb7336058b20ac409ffbfd5bc3ed97a9060b2378"
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
