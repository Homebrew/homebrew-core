class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.408.tgz"
  sha256 "16f73d4281d00ddbd549d5dbe574d0f2cf0aec34f276f91bd6ae63fe1001473e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ca302128b320fd700103d02c9d1b65e0b2bb11e90e7555e064d2b50a644d3ae0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove empty directory to make all bottle
    rm_r libexec/"lib/node_modules/pyright/node_modules" if OS.mac?
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
