class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.38.1.tgz"
  sha256 "73bda982b9d4a9cd3dd17955d33e094a73e9e990b632f79dfc81f099c3534c04"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "78200751814fec0cb10c75406db70be454feec0284e22115a357c440f69cc093"
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
