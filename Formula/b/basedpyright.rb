class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.24.0.tgz"
  sha256 "aeb5015f8f15b4bed5ee37d03e639e82c3e149e2a9152bc9e8da06da043ff031"
  license "MIT"
  head "https://github.com/detachhead/basedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3df1ff229389176bbf994a5ad77098915b9c34fb6b03ff6e91012459a5d5181"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3df1ff229389176bbf994a5ad77098915b9c34fb6b03ff6e91012459a5d5181"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3df1ff229389176bbf994a5ad77098915b9c34fb6b03ff6e91012459a5d5181"
    sha256 cellar: :any_skip_relocation, sonoma:        "1927b7bb84d73a38aa260c099b2a582b2f2f6ccec5d4e332250b5a564b59a0dc"
    sha256 cellar: :any_skip_relocation, ventura:       "1927b7bb84d73a38aa260c099b2a582b2f2f6ccec5d4e332250b5a564b59a0dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3df1ff229389176bbf994a5ad77098915b9c34fb6b03ff6e91012459a5d5181"
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
