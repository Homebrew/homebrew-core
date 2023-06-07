require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.313.tgz"
  sha256 "258813417419ea2990682419e44b03a285b894609eb3d28ae89ae436afc789cb"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98182cf0abb14bf362f8b61c667f03dfab3138d512fce75d5de3bef5d02fa39a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98182cf0abb14bf362f8b61c667f03dfab3138d512fce75d5de3bef5d02fa39a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98182cf0abb14bf362f8b61c667f03dfab3138d512fce75d5de3bef5d02fa39a"
    sha256 cellar: :any_skip_relocation, ventura:        "43761bd6be5371dd3fa6a0943e2d4fd17f6bdb77289831e447f1c129636e537d"
    sha256 cellar: :any_skip_relocation, monterey:       "43761bd6be5371dd3fa6a0943e2d4fd17f6bdb77289831e447f1c129636e537d"
    sha256 cellar: :any_skip_relocation, big_sur:        "43761bd6be5371dd3fa6a0943e2d4fd17f6bdb77289831e447f1c129636e537d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98182cf0abb14bf362f8b61c667f03dfab3138d512fce75d5de3bef5d02fa39a"
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
