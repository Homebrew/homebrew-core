class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.26.0.tgz"
  sha256 "6bdccee34df40776cf20c7a0d6baa325f389edf82a27d659dba50146a1b895e9"
  license "MIT"
  head "https://github.com/detachhead/basedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a033658be3a1a32fd3f767a1accc157a56359a9aa2711025314b9b24ab9b81a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a033658be3a1a32fd3f767a1accc157a56359a9aa2711025314b9b24ab9b81a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a033658be3a1a32fd3f767a1accc157a56359a9aa2711025314b9b24ab9b81a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "031ee6fca017cd844847defd29792f2795b1c02b4102c3472b65ed8627a78b54"
    sha256 cellar: :any_skip_relocation, ventura:       "031ee6fca017cd844847defd29792f2795b1c02b4102c3472b65ed8627a78b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a033658be3a1a32fd3f767a1accc157a56359a9aa2711025314b9b24ab9b81a1"
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
