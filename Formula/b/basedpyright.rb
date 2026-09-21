class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://docs.basedpyright.com"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.40.1.tgz"
  sha256 "150c7afc22d8274eb3f42e1403e733d3ec70cc4a8782caa56b303b3029791435"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b58fbdd60d75d8f8e7cb03163c00706c6e66ff19a8d7342aae724b9ca302a501"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/pyright" => "basedpyright"
    bin.install_symlink libexec/"bin/pyright-langserver" => "basedpyright-langserver"

    # Remove empty folder to make :all bottle
    rm_r libexec/"lib/node_modules/basedpyright/node_modules" if OS.mac?
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
