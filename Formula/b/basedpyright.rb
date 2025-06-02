class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.29.2.tgz"
  sha256 "0b4102241d807938f76e537da040f6d0b0342c8f7bb2606f28a862abc5f71ba5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89b2e69f3e73011b862309ae6c7860f3fdd65434e01891bdaec4767279402148"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89b2e69f3e73011b862309ae6c7860f3fdd65434e01891bdaec4767279402148"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89b2e69f3e73011b862309ae6c7860f3fdd65434e01891bdaec4767279402148"
    sha256 cellar: :any_skip_relocation, sonoma:        "52024ff55b370f0191ccb786fc57fe4bbf2b9c6806f1bf246d5060d1aec12c44"
    sha256 cellar: :any_skip_relocation, ventura:       "52024ff55b370f0191ccb786fc57fe4bbf2b9c6806f1bf246d5060d1aec12c44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89b2e69f3e73011b862309ae6c7860f3fdd65434e01891bdaec4767279402148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89b2e69f3e73011b862309ae6c7860f3fdd65434e01891bdaec4767279402148"
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
