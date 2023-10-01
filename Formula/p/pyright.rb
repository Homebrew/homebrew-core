require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.328.tgz"
  sha256 "17559f105d6b0bf0126d3d4fce8e2f7677fce22a50d261e5ae5e62bfb5765ba2"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a391771668e5e449676cca29d67a0fbc3eb102c73e15ea911d1e0eaccc72ed4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a391771668e5e449676cca29d67a0fbc3eb102c73e15ea911d1e0eaccc72ed4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a391771668e5e449676cca29d67a0fbc3eb102c73e15ea911d1e0eaccc72ed4"
    sha256 cellar: :any_skip_relocation, ventura:        "576c8464157339dd4eeea66f8f314c9157448a12d2da2ce596f972759dafb92c"
    sha256 cellar: :any_skip_relocation, monterey:       "576c8464157339dd4eeea66f8f314c9157448a12d2da2ce596f972759dafb92c"
    sha256 cellar: :any_skip_relocation, big_sur:        "576c8464157339dd4eeea66f8f314c9157448a12d2da2ce596f972759dafb92c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "541a9953d79138d509ff04b0014ee630023e7cc13f5a598ac52434bdf6917468"
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
