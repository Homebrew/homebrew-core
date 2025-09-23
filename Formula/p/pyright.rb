class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.405.tgz"
  sha256 "4fe97e11606a86f0f4166b05d23b71a1e4e5f3a47ca64de161615f27545f1e9c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7d052f0f8cff8a4e8d8e106f4725da6306173e7cd39bb7a7b7a93677810b4848"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
