require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.290.tgz"
  sha256 "7272f0eeac3664a35da00858e585b3927dfcde3a64957e455f2602f6e1417b18"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4499b878da919114dcc36b6967f8e909d84986b10517f82ea329a20fc8d99221"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4499b878da919114dcc36b6967f8e909d84986b10517f82ea329a20fc8d99221"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4499b878da919114dcc36b6967f8e909d84986b10517f82ea329a20fc8d99221"
    sha256 cellar: :any_skip_relocation, ventura:        "0816580e424789bddb2ccca5e0abd61e75a2a1445ca8b792030a95c9c8dd038e"
    sha256 cellar: :any_skip_relocation, monterey:       "0816580e424789bddb2ccca5e0abd61e75a2a1445ca8b792030a95c9c8dd038e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0816580e424789bddb2ccca5e0abd61e75a2a1445ca8b792030a95c9c8dd038e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4499b878da919114dcc36b6967f8e909d84986b10517f82ea329a20fc8d99221"
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
