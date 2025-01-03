class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.23.1.tgz"
  sha256 "f9f85aba376f90426e0844d8bb39bc6cfc2f1a5dee69db12a6abe3ff3d04b6b0"
  license "MIT"
  head "https://github.com/detachhead/basedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cb28ae6243fe10d2efd89f10ae4572b6e8c3538a5a5064de135450684d3d676"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cb28ae6243fe10d2efd89f10ae4572b6e8c3538a5a5064de135450684d3d676"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7cb28ae6243fe10d2efd89f10ae4572b6e8c3538a5a5064de135450684d3d676"
    sha256 cellar: :any_skip_relocation, sonoma:        "26008bdec14852ea008c1460645e3f9117a9c73bdb71e2da290235ab6e415237"
    sha256 cellar: :any_skip_relocation, ventura:       "26008bdec14852ea008c1460645e3f9117a9c73bdb71e2da290235ab6e415237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cb28ae6243fe10d2efd89f10ae4572b6e8c3538a5a5064de135450684d3d676"
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
