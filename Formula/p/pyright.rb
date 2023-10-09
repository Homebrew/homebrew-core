require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.330.tgz"
  sha256 "36d9c9776a001e29baa52ecb85a57cb7cffccce21e9cb5b46c18636d339f624b"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f001d4e1f870df8e26d8b5036668af2c6adfd7a700e2ed9c5ab68e1214ec3a64"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f001d4e1f870df8e26d8b5036668af2c6adfd7a700e2ed9c5ab68e1214ec3a64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f001d4e1f870df8e26d8b5036668af2c6adfd7a700e2ed9c5ab68e1214ec3a64"
    sha256 cellar: :any_skip_relocation, sonoma:         "1358c4c149afd64b33483a8cede194e8b677cafce87a8f41db9f6667efeea07f"
    sha256 cellar: :any_skip_relocation, ventura:        "1358c4c149afd64b33483a8cede194e8b677cafce87a8f41db9f6667efeea07f"
    sha256 cellar: :any_skip_relocation, monterey:       "1358c4c149afd64b33483a8cede194e8b677cafce87a8f41db9f6667efeea07f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdd1b3c707e8009024d3dca8d00c02422cfe9b570ea89271d8fd33a1be68e264"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match 'error: Expression of type "int" cannot be assigned to return type "str"', output
  end
end
