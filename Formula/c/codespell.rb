class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/e1/97/df3e00b4d795c96233e35d269c211131c5572503d2270afb6fed7d859cc2/codespell-2.2.6.tar.gz"
  sha256 "a8c65d8eb3faa03deabab6b3bbe798bea72e1799c7e9e955d57eca4096abcff9"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffd5d8a44b48858c9882083acbd5abaddd612a1019d80cc502ad1b41d75d6bb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3854426224f0d3d07fd3f400dcb56eccf7b69efe46377871ef0e35e512e45fb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fc5b733f9670d830760e980b5d0e0b96f41ecce6e294a77ae5935fb3b1308a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa7711e4c842edeca00598e2a13cf19e2d3874bb09847b08e0d4ac2042bb6ff4"
    sha256 cellar: :any_skip_relocation, ventura:        "f8aa834fd9afb8964095c36e2c8d80f6cc233769c20fc5109c1570d908950b41"
    sha256 cellar: :any_skip_relocation, monterey:       "0d331809dd115374560dfa34fc928c6ae28786cef02a3c2a0d23a839496abc50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be12c81122de1ef61972790e8d51ead7e81fbd577e4bf356f096abfc475c2a3b"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", pipe_output("#{bin}/codespell -", "teh", 65)
  end
end
