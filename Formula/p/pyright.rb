class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.406.tgz"
  sha256 "e3387caa16d30fcc90a1495caa10eb1bae47413cfe5391f0378bbdb6c76c1635"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "39f1e78737d43519087ad5617009671292a72514c1be827355299530b51d436d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
