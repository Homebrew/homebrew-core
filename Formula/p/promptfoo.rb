class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.93.3.tgz"
  sha256 "be012fef1f57ce5c4652dbe948c227cb8669c340a179ab866275324c02569c72"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c98631a8198e4260bbc8eeeb13c34766b643d1f31be3ffc94762bd09ec73463"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a7976ec4c2885e1000b6e9a52296a45a6dc47dce49944de7a460d19e7b85c79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42a3753f759c431dfa2df21fb8c0fc891233ccaf518d2323c08fbdfce51a8d48"
    sha256 cellar: :any_skip_relocation, sonoma:        "554f52c85214ee7f53972ea6b8aefafa05cb8915558e3ed5601e093ab9a86475"
    sha256 cellar: :any_skip_relocation, ventura:       "b43860324b7b989950a0a901f1a9e34f68107570d1dcd2f5a3c1de6ab96dbc0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ac702aec544981fc71d7e3a009eae529f7347bd8188625173c513697e180f70"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
