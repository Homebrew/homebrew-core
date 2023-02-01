require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.292.tgz"
  sha256 "92bc064fdd2f3d57d5b15ac7f3c04b59e70b02004f0adfbcb050b015cbfba879"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fdacd10eb1b160d5f22ff8986ffd8dc0b841536f1da13e0a4a9ac463f8b74172"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdacd10eb1b160d5f22ff8986ffd8dc0b841536f1da13e0a4a9ac463f8b74172"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdacd10eb1b160d5f22ff8986ffd8dc0b841536f1da13e0a4a9ac463f8b74172"
    sha256 cellar: :any_skip_relocation, ventura:        "29b69324ca86330d7799e71eeae4788fc5ee70e2fa146fb0a8491722567a5803"
    sha256 cellar: :any_skip_relocation, monterey:       "29b69324ca86330d7799e71eeae4788fc5ee70e2fa146fb0a8491722567a5803"
    sha256 cellar: :any_skip_relocation, big_sur:        "29b69324ca86330d7799e71eeae4788fc5ee70e2fa146fb0a8491722567a5803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdacd10eb1b160d5f22ff8986ffd8dc0b841536f1da13e0a4a9ac463f8b74172"
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
