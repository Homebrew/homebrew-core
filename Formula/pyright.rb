require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.160.tgz"
  sha256 "c45bbdbcbb1a1c0e9c929cf3aa213178655eacaea9b9fe0400dad7330ab9b36a"
  license "MIT"
  head "https://github.com/microsoft/pyright.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aac678152017942fe3405be8a721a8bbfcb5db85eab576c31bc6cafe386db0e2"
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
