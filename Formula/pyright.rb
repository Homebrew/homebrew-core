require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.303.tgz"
  sha256 "cc92ee0907b414ece3d37dbc6af920be3b735e8886743337265df48ccb111753"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7b09d8444c46a3494a462705dd370836902a0a4771a2251c8aa382bbf461e04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7b09d8444c46a3494a462705dd370836902a0a4771a2251c8aa382bbf461e04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7b09d8444c46a3494a462705dd370836902a0a4771a2251c8aa382bbf461e04"
    sha256 cellar: :any_skip_relocation, ventura:        "a376285d0005058bb96d9f49d2e5ef26f9d74726ed494aac2ef1f772b79671ae"
    sha256 cellar: :any_skip_relocation, monterey:       "a376285d0005058bb96d9f49d2e5ef26f9d74726ed494aac2ef1f772b79671ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "a376285d0005058bb96d9f49d2e5ef26f9d74726ed494aac2ef1f772b79671ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7b09d8444c46a3494a462705dd370836902a0a4771a2251c8aa382bbf461e04"
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
