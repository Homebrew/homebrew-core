require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.292.tgz"
  sha256 "92bc064fdd2f3d57d5b15ac7f3c04b59e70b02004f0adfbcb050b015cbfba879"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2edd1c86e63bdec190e27d2586d648f74c2c673370b05812583084f14d56c83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2edd1c86e63bdec190e27d2586d648f74c2c673370b05812583084f14d56c83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2edd1c86e63bdec190e27d2586d648f74c2c673370b05812583084f14d56c83"
    sha256 cellar: :any_skip_relocation, ventura:        "9a8d05acabb9c59c7459bad8b36196b4fa7edea45fd983ac50a61f9e463c4020"
    sha256 cellar: :any_skip_relocation, monterey:       "9a8d05acabb9c59c7459bad8b36196b4fa7edea45fd983ac50a61f9e463c4020"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a8d05acabb9c59c7459bad8b36196b4fa7edea45fd983ac50a61f9e463c4020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2edd1c86e63bdec190e27d2586d648f74c2c673370b05812583084f14d56c83"
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
