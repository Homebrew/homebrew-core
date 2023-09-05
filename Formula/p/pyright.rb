require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.325.tgz"
  sha256 "be15bcc907bea7e79d0be210c70cff086b556bad68e1e4427150bb797c80092b"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1a527bb58734638dc54e4785eb370b2804b260f0dfb5bd1c74722706b74192e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1a527bb58734638dc54e4785eb370b2804b260f0dfb5bd1c74722706b74192e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1a527bb58734638dc54e4785eb370b2804b260f0dfb5bd1c74722706b74192e"
    sha256 cellar: :any_skip_relocation, ventura:        "78a87966fd1269bba430d7bfd67d2b24b278eb73ecb6adcbc1721ed356a49842"
    sha256 cellar: :any_skip_relocation, monterey:       "78a87966fd1269bba430d7bfd67d2b24b278eb73ecb6adcbc1721ed356a49842"
    sha256 cellar: :any_skip_relocation, big_sur:        "78a87966fd1269bba430d7bfd67d2b24b278eb73ecb6adcbc1721ed356a49842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ed8b8bd76c57d6c52f010b99a5de01011e711a7f437dc7bd08490f89d4154ea"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Replace universal binaries with native slices
    deuniversalize_machos
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
