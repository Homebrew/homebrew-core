class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.103.13.tgz"
  sha256 "1e2e9f64bb48278af44a86d2fb9d248cb1fdd7eed566b67e6a21f81a9236ed33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba9e0c7d5aae7b76869e6cbaca7bc26a5b08679b882189d13434141ab562572b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7592489dc2b337a19780732bb96e7f8408e696a98142fb85dddcea45ff3b94fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff5afbb22e587c8d08817a08ea13c98eb30121e81988f3b8186e9381480a1325"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8fe241895e338565838eb789244f9035e5b6321987b6bd1811b641cdb9e68b6"
    sha256 cellar: :any_skip_relocation, ventura:       "4a94e15cc49b49881fc8e3376254a16c8dd7031155ed9d26060c5494b5f6024d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb1ce51148f04b35ad262396da88ed5572c6f901a95014f4ebe878b6d3f072a4"
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
