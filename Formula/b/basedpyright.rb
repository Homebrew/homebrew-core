class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.29.1.tgz"
  sha256 "97859fe21af1d8601fe5f1cbd7d68f0db156524e4b3bc8306730ab22533cec81"
  license "MIT"
  head "https://github.com/detachhead/basedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c08d5edd65107b8429513c225383d3296711b7834ac54ec7c643c6ff35c57af9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c08d5edd65107b8429513c225383d3296711b7834ac54ec7c643c6ff35c57af9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c08d5edd65107b8429513c225383d3296711b7834ac54ec7c643c6ff35c57af9"
    sha256 cellar: :any_skip_relocation, sonoma:        "55028a5193fe2169d4229d2cc0670af5e52298869064d624cb93a1592c639b06"
    sha256 cellar: :any_skip_relocation, ventura:       "55028a5193fe2169d4229d2cc0670af5e52298869064d624cb93a1592c639b06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c08d5edd65107b8429513c225383d3296711b7834ac54ec7c643c6ff35c57af9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c08d5edd65107b8429513c225383d3296711b7834ac54ec7c643c6ff35c57af9"
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
