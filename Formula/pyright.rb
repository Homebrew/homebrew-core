require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.316.tgz"
  sha256 "74504aa3c425fd03343e8d02ba3b8ccca9ff89f647a5c9ce06fda26bfc11564b"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6fb5c8d1f14f5b9070cfc33aee76ef92386a586ff31d896d2c3e7fea0c06334"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6fb5c8d1f14f5b9070cfc33aee76ef92386a586ff31d896d2c3e7fea0c06334"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6fb5c8d1f14f5b9070cfc33aee76ef92386a586ff31d896d2c3e7fea0c06334"
    sha256 cellar: :any_skip_relocation, ventura:        "030dea9509074f3e063fbf2389d8167a1bb726d42777c8948552882ace9c5198"
    sha256 cellar: :any_skip_relocation, monterey:       "030dea9509074f3e063fbf2389d8167a1bb726d42777c8948552882ace9c5198"
    sha256 cellar: :any_skip_relocation, big_sur:        "030dea9509074f3e063fbf2389d8167a1bb726d42777c8948552882ace9c5198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6fb5c8d1f14f5b9070cfc33aee76ef92386a586ff31d896d2c3e7fea0c06334"
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
