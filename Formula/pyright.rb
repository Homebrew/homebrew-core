require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.283.tgz"
  sha256 "30763e0e65cb5caf05e9b54688e11e0eae7c97b926084a3d1cc01cc512c52357"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4693f9a90a65946845cfbdb67f71d38f2f9a4a538b4f209bcb76d6de23e67d65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4693f9a90a65946845cfbdb67f71d38f2f9a4a538b4f209bcb76d6de23e67d65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4693f9a90a65946845cfbdb67f71d38f2f9a4a538b4f209bcb76d6de23e67d65"
    sha256 cellar: :any_skip_relocation, ventura:        "6c31a59cabd882dedbeaeec6d67576341b5d3e8517766a0d4da97094521fdd23"
    sha256 cellar: :any_skip_relocation, monterey:       "6c31a59cabd882dedbeaeec6d67576341b5d3e8517766a0d4da97094521fdd23"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c31a59cabd882dedbeaeec6d67576341b5d3e8517766a0d4da97094521fdd23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4693f9a90a65946845cfbdb67f71d38f2f9a4a538b4f209bcb76d6de23e67d65"
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
