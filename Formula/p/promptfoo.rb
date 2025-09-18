class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.118.5.tgz"
  sha256 "5f12e4e2c267997101cbff6212c508eb540e1758dce3e1602812c1be389c4ee4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dec4ece7f733dbf6a8cb8eba97baa150659ac8529f0ad93b40c0485f1b9ab15a"
    sha256 cellar: :any,                 arm64_sequoia: "313bb5ae9bcc22bf4795d71d25674654f541e4de9d856aafca74764c8cb1712b"
    sha256 cellar: :any,                 arm64_sonoma:  "390c96f86a1c4f4184c409feaee685ee01186ed31ace6cfca95bd2e65c7bce04"
    sha256 cellar: :any,                 sonoma:        "973f931d3d7acc3597ea212cccef9368cd617e156724bf7a478631a8c691a5d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6982ed780924c6d704876098c3ce91aa201615ebe8a2f644fd0e6adf548dd9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c50370e8c470ea963dab585b10cc3da7d6752b671f5e07f3bf018cd27649ec3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
