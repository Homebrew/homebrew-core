require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.161.tgz"
  sha256 "c267a4dff0d2266f63ec2b0afcb54d74e1bace3dc03f8edfba79bcafc7839920"
  license "MIT"
  head "https://github.com/microsoft/pyright.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2eca87f2f1b6eee41683666f27194423b078211dc8169f2ff1c5f812a1bb1b80"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
