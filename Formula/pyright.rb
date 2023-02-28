require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.296.tgz"
  sha256 "362a51357b44b6b893df06cf40f585599a961d076a01cbab83e7cfd42458c2a6"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a8700842eea745e39e2adf04523204627b1dc2697815d5f712f3b6d63d4df6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a8700842eea745e39e2adf04523204627b1dc2697815d5f712f3b6d63d4df6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a8700842eea745e39e2adf04523204627b1dc2697815d5f712f3b6d63d4df6c"
    sha256 cellar: :any_skip_relocation, ventura:        "00abf24a233ba56c330a1b28c9d431e220a6223859fc1506a159298d92d4783e"
    sha256 cellar: :any_skip_relocation, monterey:       "00abf24a233ba56c330a1b28c9d431e220a6223859fc1506a159298d92d4783e"
    sha256 cellar: :any_skip_relocation, big_sur:        "00abf24a233ba56c330a1b28c9d431e220a6223859fc1506a159298d92d4783e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a8700842eea745e39e2adf04523204627b1dc2697815d5f712f3b6d63d4df6c"
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
