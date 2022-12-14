require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.284.tgz"
  sha256 "c0a87041c1eaae90abebdd22d454da83caea196fd86b917eb0bf1293c600547e"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "342d4dfdb9875d8c84e31ef9a7ebca5c3e95bf5de6af349250c4085422effcee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "342d4dfdb9875d8c84e31ef9a7ebca5c3e95bf5de6af349250c4085422effcee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "342d4dfdb9875d8c84e31ef9a7ebca5c3e95bf5de6af349250c4085422effcee"
    sha256 cellar: :any_skip_relocation, ventura:        "7dda9b85471495b3ca4faaf670873a758d45ecabbf24a22004517c5ae2545f79"
    sha256 cellar: :any_skip_relocation, monterey:       "7dda9b85471495b3ca4faaf670873a758d45ecabbf24a22004517c5ae2545f79"
    sha256 cellar: :any_skip_relocation, big_sur:        "7dda9b85471495b3ca4faaf670873a758d45ecabbf24a22004517c5ae2545f79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "342d4dfdb9875d8c84e31ef9a7ebca5c3e95bf5de6af349250c4085422effcee"
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
