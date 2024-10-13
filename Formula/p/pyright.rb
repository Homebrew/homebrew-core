class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.384.tgz"
  sha256 "e14e5c6842def12e5acd6383a2251c6ec17ad77650c5f1fefdade88bfa3f1d9d"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8aca30c321440d3c0351506612be2ee6c8b777f554ab329dd86d9aeb8b54105c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8aca30c321440d3c0351506612be2ee6c8b777f554ab329dd86d9aeb8b54105c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8aca30c321440d3c0351506612be2ee6c8b777f554ab329dd86d9aeb8b54105c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cf0a0bb7e6e44071573737d2155995bfaf028d9d8703dc3661d9cf317c79633"
    sha256 cellar: :any_skip_relocation, ventura:       "1cf0a0bb7e6e44071573737d2155995bfaf028d9d8703dc3661d9cf317c79633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aca30c321440d3c0351506612be2ee6c8b777f554ab329dd86d9aeb8b54105c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
