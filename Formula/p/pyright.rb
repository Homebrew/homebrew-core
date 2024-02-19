require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.350.tgz"
  sha256 "d3bc2b74950884c7e362df0f3728bb58c112f16f9a122d18ea177ba8c6845626"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "814450fb038270d36dcb7957c1dfd91bc654cd80170275ea3a9b92e68a29c4a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "814450fb038270d36dcb7957c1dfd91bc654cd80170275ea3a9b92e68a29c4a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "814450fb038270d36dcb7957c1dfd91bc654cd80170275ea3a9b92e68a29c4a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "967fcaf17d48418504fd41b15836795bcd474016d65d6b15a86fe1d626fadd54"
    sha256 cellar: :any_skip_relocation, ventura:        "967fcaf17d48418504fd41b15836795bcd474016d65d6b15a86fe1d626fadd54"
    sha256 cellar: :any_skip_relocation, monterey:       "967fcaf17d48418504fd41b15836795bcd474016d65d6b15a86fe1d626fadd54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c559ad55e01f7a291013f7bd96e510dc15a620202057b2b0ee0182b02a12fe28"
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
