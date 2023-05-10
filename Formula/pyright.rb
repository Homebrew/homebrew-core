require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.307.tgz"
  sha256 "8aa5c2e64d942ebba626439a880ffc1fbc810a09c77d916681fd70bbb37e121d"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3db06695ed354226d708d3b77519893b09f5cd96027b5cbd37f8a958d8f3e821"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3db06695ed354226d708d3b77519893b09f5cd96027b5cbd37f8a958d8f3e821"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3db06695ed354226d708d3b77519893b09f5cd96027b5cbd37f8a958d8f3e821"
    sha256 cellar: :any_skip_relocation, ventura:        "c183d455912a396de56c34e636c1f1ee919e5c3d175725ec92c0c485d58a8156"
    sha256 cellar: :any_skip_relocation, monterey:       "c183d455912a396de56c34e636c1f1ee919e5c3d175725ec92c0c485d58a8156"
    sha256 cellar: :any_skip_relocation, big_sur:        "c183d455912a396de56c34e636c1f1ee919e5c3d175725ec92c0c485d58a8156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3db06695ed354226d708d3b77519893b09f5cd96027b5cbd37f8a958d8f3e821"
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
