class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.39.6.tgz"
  sha256 "1e16e55e52a1a8b19b90647b8f72f39ba1508075b0b0a0d5c3dd87380e82685d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fd316216ec6da5bc9090266fa14ad9091f040f52dd64238137ff33ed3ec40072"
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
