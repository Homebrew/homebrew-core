class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.114.0.tgz"
  sha256 "4c66f2b52d654dd6b50b1684d3c3a07cdd47c98757f37253953036e1537c26f9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e5ae90ab30191068da3a18c1bcd209eb1b4e328f58ad525c1bea068c57db8cc4"
    sha256 cellar: :any,                 arm64_sonoma:  "4a2b39c90cff2b6099f461c42a7b56e494eca693c334c4200235b6b8046a799f"
    sha256 cellar: :any,                 arm64_ventura: "41b475c684f71e170e1b8f1a26dce3a0f2e37420b86d3be0da3739d02cea3920"
    sha256                               sonoma:        "8b6bbf0ff640615f8f8ba9254b1a6d9f880c4f10c1b523151861cef96e94c441"
    sha256                               ventura:       "7468696c76e2fdfc311c94ea6423c9c1f41d3365c3d01f5092e2a32ca3e17151"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d298877e641aa30f9a4de5cf487f7395fe1b8d399ad909113b6db28f3d5daac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5b60097fcfee7ca2a26451dc88955ccc7a108911cfc4ac246873d5d75b0174f"
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
