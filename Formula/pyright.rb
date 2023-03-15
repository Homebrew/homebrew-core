require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.299.tgz"
  sha256 "806c584d9dda17957d618db64dc62910445305df62a5a87220b50b75adfff49f"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3dbbe3544850180c409e8c2553319eed4d3dc29ca8b2e64da5ac2760bcae9749"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dbbe3544850180c409e8c2553319eed4d3dc29ca8b2e64da5ac2760bcae9749"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3dbbe3544850180c409e8c2553319eed4d3dc29ca8b2e64da5ac2760bcae9749"
    sha256 cellar: :any_skip_relocation, ventura:        "1e0ed6d980ed1506f67e38b91e24838aee601c8dc73412ccc014496ceef6abbb"
    sha256 cellar: :any_skip_relocation, monterey:       "1e0ed6d980ed1506f67e38b91e24838aee601c8dc73412ccc014496ceef6abbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e0ed6d980ed1506f67e38b91e24838aee601c8dc73412ccc014496ceef6abbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dbbe3544850180c409e8c2553319eed4d3dc29ca8b2e64da5ac2760bcae9749"
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
