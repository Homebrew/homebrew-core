require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.291.tgz"
  sha256 "59f3c7c9f18eac2425932fc58132704118ca93089fe0d3042df6bfb2744ff14a"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95f56aa23e85e11d51fd3cdc1596e1060351a796fc075ac74d73f2889d21620d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95f56aa23e85e11d51fd3cdc1596e1060351a796fc075ac74d73f2889d21620d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95f56aa23e85e11d51fd3cdc1596e1060351a796fc075ac74d73f2889d21620d"
    sha256 cellar: :any_skip_relocation, ventura:        "1304f4c7364ad7d3b5afb4f9994db1c0e16d0c5b784f247f10e5bb6d4e9fd14a"
    sha256 cellar: :any_skip_relocation, monterey:       "1304f4c7364ad7d3b5afb4f9994db1c0e16d0c5b784f247f10e5bb6d4e9fd14a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1304f4c7364ad7d3b5afb4f9994db1c0e16d0c5b784f247f10e5bb6d4e9fd14a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95f56aa23e85e11d51fd3cdc1596e1060351a796fc075ac74d73f2889d21620d"
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
