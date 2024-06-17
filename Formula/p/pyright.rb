require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.367.tgz"
  sha256 "79696b847b6f121521c8c5840e0b47e8ed75f1f4167145f0e3954abc9f880088"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5309c515f580032ddedb574a6a6722880ee023a561c84b60ee1460159f03fd3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5309c515f580032ddedb574a6a6722880ee023a561c84b60ee1460159f03fd3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5309c515f580032ddedb574a6a6722880ee023a561c84b60ee1460159f03fd3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c75e76c27fc6b2c7cf2f76df6116e5f52eb5fe9bce7fb8bb2b945357a99c2d2a"
    sha256 cellar: :any_skip_relocation, ventura:        "c75e76c27fc6b2c7cf2f76df6116e5f52eb5fe9bce7fb8bb2b945357a99c2d2a"
    sha256 cellar: :any_skip_relocation, monterey:       "c75e76c27fc6b2c7cf2f76df6116e5f52eb5fe9bce7fb8bb2b945357a99c2d2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2950adfeeca37cc5c5ed1dc578399374d1688c4bfb0d4756d9f0e1c8a1e0134a"
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
    assert_match "error: Expression of type \"int\" is incompatible with return type \"str\"", output
  end
end
