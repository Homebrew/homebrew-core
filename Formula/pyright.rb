require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.288.tgz"
  sha256 "8c78e5b8a23b72af2a597f2a1f1f6c57ff4882f0af8031cbdce0d9aef12c07dc"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76fb78ba5f7275e8997ef00166a183d10993b08a8a9bf4c5491f3c1e5e5cb036"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76fb78ba5f7275e8997ef00166a183d10993b08a8a9bf4c5491f3c1e5e5cb036"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76fb78ba5f7275e8997ef00166a183d10993b08a8a9bf4c5491f3c1e5e5cb036"
    sha256 cellar: :any_skip_relocation, ventura:        "b5bc3216819c61c0955dcf045d8a83846e96fe21820234cd797838ca151eefd9"
    sha256 cellar: :any_skip_relocation, monterey:       "b5bc3216819c61c0955dcf045d8a83846e96fe21820234cd797838ca151eefd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5bc3216819c61c0955dcf045d8a83846e96fe21820234cd797838ca151eefd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76fb78ba5f7275e8997ef00166a183d10993b08a8a9bf4c5491f3c1e5e5cb036"
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
