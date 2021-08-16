require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.162.tgz"
  sha256 "626019b9857978f948b951b854e0e830c237ac88a6fa2136e594158f54b295e6"
  license "MIT"
  head "https://github.com/microsoft/pyright.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "14bb8ffd218aee0c88f9b5b9d6e4823502f9f5319de24aadb17d8397624f8c3e"
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
