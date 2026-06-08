class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.410.tgz"
  sha256 "4d6b7a25f9617ea8ff7b2e98cd87c146d132a95cbfb29bf58bd638018a76ac48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a017c970d32d04002a054d6d5889f47c4f728282d79933d3b216f8f09e3c9bbf"
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
