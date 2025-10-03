class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.31.6.tgz"
  sha256 "062fc07bdd87cdd767f9195c528a9fd1a8f7762ce0104caa35502335ac866e20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "be596bcfb3e0afc66fc7f23fe06cfcd2efd77fd0d35fbdb50939ba0f0c064d59"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/pyright" => "basedpyright"
    bin.install_symlink libexec/"bin/pyright-langserver" => "basedpyright-langserver"
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = shell_output("#{bin}/basedpyright broken.py 2>&1", 1)
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
