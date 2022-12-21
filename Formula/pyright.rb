require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.285.tgz"
  sha256 "1a2c764e5c2cbe572ce4446c84fdb7586ec3307f96006f659fc06d62968643ef"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eebdf243afbcb40ee3233787c8755d95b62680b45b6575de64ab2b1cc9e649a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eebdf243afbcb40ee3233787c8755d95b62680b45b6575de64ab2b1cc9e649a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eebdf243afbcb40ee3233787c8755d95b62680b45b6575de64ab2b1cc9e649a6"
    sha256 cellar: :any_skip_relocation, ventura:        "1cc12872eb3d15c7d9639a444e78f3013be75c27f2babad7f607204d636d5e6c"
    sha256 cellar: :any_skip_relocation, monterey:       "1cc12872eb3d15c7d9639a444e78f3013be75c27f2babad7f607204d636d5e6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cc12872eb3d15c7d9639a444e78f3013be75c27f2babad7f607204d636d5e6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eebdf243afbcb40ee3233787c8755d95b62680b45b6575de64ab2b1cc9e649a6"
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
