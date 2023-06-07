require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.312.tgz"
  sha256 "37561df721723a157f4364b4f87ee2a90961d681fa8e863671fab928f6f5c42c"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "403ceede25edc599ea57123b62510ce992d20e58ce3a8282a1a0cf5fd513eb10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "403ceede25edc599ea57123b62510ce992d20e58ce3a8282a1a0cf5fd513eb10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "403ceede25edc599ea57123b62510ce992d20e58ce3a8282a1a0cf5fd513eb10"
    sha256 cellar: :any_skip_relocation, ventura:        "52acda81ba0e60a2fd68e64f36782a50c7c95e6b5eacb3d438ee7dbf015f1ff4"
    sha256 cellar: :any_skip_relocation, monterey:       "52acda81ba0e60a2fd68e64f36782a50c7c95e6b5eacb3d438ee7dbf015f1ff4"
    sha256 cellar: :any_skip_relocation, big_sur:        "52acda81ba0e60a2fd68e64f36782a50c7c95e6b5eacb3d438ee7dbf015f1ff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "403ceede25edc599ea57123b62510ce992d20e58ce3a8282a1a0cf5fd513eb10"
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
