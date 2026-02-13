class AxiomCli < Formula
  desc "AI SDK providing observability instrumentation for GenAI applications"
  homepage "https://github.com/axiomhq/ai"
  url "https://registry.npmjs.org/axiom/-/axiom-0.43.0.tgz"
  sha256 "ca33ad8d82eadada1045cff68bb8f9cd0d0028381967554c5a52e216aaa825ba"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/axiom --version")

    # Test help command to verify functionality
    assert_match "Axiom's CLI", shell_output("#{bin}/axiom --help")
  end
end
