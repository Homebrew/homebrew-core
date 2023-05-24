require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.310.tgz"
  sha256 "861d596966f5be02e07ee4f464556aa991720ecff33c75393bc9d274d5d30c9a"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c36acd35d43415f3a237708aff593df53b244f914e081dd2924f3e572b2bcd7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c36acd35d43415f3a237708aff593df53b244f914e081dd2924f3e572b2bcd7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c36acd35d43415f3a237708aff593df53b244f914e081dd2924f3e572b2bcd7d"
    sha256 cellar: :any_skip_relocation, ventura:        "ca92db83f5403e2d729b737886becb224bcd7f2b11b585a75a383fad1e7bfe0d"
    sha256 cellar: :any_skip_relocation, monterey:       "ca92db83f5403e2d729b737886becb224bcd7f2b11b585a75a383fad1e7bfe0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca92db83f5403e2d729b737886becb224bcd7f2b11b585a75a383fad1e7bfe0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c36acd35d43415f3a237708aff593df53b244f914e081dd2924f3e572b2bcd7d"
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
