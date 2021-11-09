require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.186.tgz"
  sha256 "4a954369f2e3b7bd5bee6edeeb5b9d52b727ac9f0bece07b921e9ff182264c84"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfc1df9cb02099d7615d32d7dc0f26db9bab1cd5ce8898862dcbd2312d555703"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfc1df9cb02099d7615d32d7dc0f26db9bab1cd5ce8898862dcbd2312d555703"
    sha256 cellar: :any_skip_relocation, monterey:       "dfc1df9cb02099d7615d32d7dc0f26db9bab1cd5ce8898862dcbd2312d555703"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfc1df9cb02099d7615d32d7dc0f26db9bab1cd5ce8898862dcbd2312d555703"
    sha256 cellar: :any_skip_relocation, catalina:       "dfc1df9cb02099d7615d32d7dc0f26db9bab1cd5ce8898862dcbd2312d555703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfc1df9cb02099d7615d32d7dc0f26db9bab1cd5ce8898862dcbd2312d555703"
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
