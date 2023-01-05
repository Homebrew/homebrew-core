require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.287.tgz"
  sha256 "90df73832c61407f5a2958b41e9593a6e9f06bc0574032e7ea4982680b35863f"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbdff452133a21bc3c7587eee1ced1a415389fe6b4955aaba47e1611f2a0545c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbdff452133a21bc3c7587eee1ced1a415389fe6b4955aaba47e1611f2a0545c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbdff452133a21bc3c7587eee1ced1a415389fe6b4955aaba47e1611f2a0545c"
    sha256 cellar: :any_skip_relocation, ventura:        "d47ab27d0d7579d4787fda959893fae08e5527a2c132b267b343eb8aeaa9cff3"
    sha256 cellar: :any_skip_relocation, monterey:       "d47ab27d0d7579d4787fda959893fae08e5527a2c132b267b343eb8aeaa9cff3"
    sha256 cellar: :any_skip_relocation, big_sur:        "d47ab27d0d7579d4787fda959893fae08e5527a2c132b267b343eb8aeaa9cff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbdff452133a21bc3c7587eee1ced1a415389fe6b4955aaba47e1611f2a0545c"
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
