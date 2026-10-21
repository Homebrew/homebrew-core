class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/50/d8/30873d2b7b57dee9263e53d142da044c4600a46f2d28374b3e38b023df16/autopep8-2.3.2.tar.gz"
  sha256 "89440a4f969197b69a995e4ce0661b031f455a9f776d2c5ba3dbd83466931758"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "6e70822190aa64df84e0f9da826f5953719d5aba27a906a6d8b07461fa179fd8"
  end

  depends_on "python@3.15"

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/86/df/178e41c9ed0ff33c23b3f3757e4e658c889f9abc5ad76ece6cd607b12e9c/pycodestyle-2.15.0.tar.gz"
    sha256 "318f5db083869b4c4dad922d0b11124fb27ab181b6730b93371da671e31bd50e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/autopep8 -", "x='homebrew'", 0)
    assert_equal "x = 'homebrew'", output.strip
  end
end
