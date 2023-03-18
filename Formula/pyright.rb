require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.299.tgz"
  sha256 "806c584d9dda17957d618db64dc62910445305df62a5a87220b50b75adfff49f"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3df79300ed6f87e3600f07ba74bd0e32de65d92a5f9ef8ab198ddf3b0f1c7abc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3df79300ed6f87e3600f07ba74bd0e32de65d92a5f9ef8ab198ddf3b0f1c7abc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3df79300ed6f87e3600f07ba74bd0e32de65d92a5f9ef8ab198ddf3b0f1c7abc"
    sha256 cellar: :any_skip_relocation, ventura:        "d8b4bd0880a8333e159b3bd08b3e47838d9158d10512c6f0b734eb0f302d8f72"
    sha256 cellar: :any_skip_relocation, monterey:       "d8b4bd0880a8333e159b3bd08b3e47838d9158d10512c6f0b734eb0f302d8f72"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8b4bd0880a8333e159b3bd08b3e47838d9158d10512c6f0b734eb0f302d8f72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3df79300ed6f87e3600f07ba74bd0e32de65d92a5f9ef8ab198ddf3b0f1c7abc"
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
