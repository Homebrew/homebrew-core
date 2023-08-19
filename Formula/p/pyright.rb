require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.323.tgz"
  sha256 "007479768bffe6403a5fc30190f3e2a1f05019bc2e8cf0896ffdad47ce76f53a"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1710b8c8f3c50c80763b566cbbd68cc43e16f8152b89e29e83891b015828754"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1710b8c8f3c50c80763b566cbbd68cc43e16f8152b89e29e83891b015828754"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1710b8c8f3c50c80763b566cbbd68cc43e16f8152b89e29e83891b015828754"
    sha256 cellar: :any_skip_relocation, ventura:        "a6aae82c724983c2704714ecf2890c5e5de3b941f3e4bce6e32e95f96cc8f996"
    sha256 cellar: :any_skip_relocation, monterey:       "a6aae82c724983c2704714ecf2890c5e5de3b941f3e4bce6e32e95f96cc8f996"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6aae82c724983c2704714ecf2890c5e5de3b941f3e4bce6e32e95f96cc8f996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e92957ee170067170d301947a85c5799d0218383afbe2ece09255d09dd6df701"
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
