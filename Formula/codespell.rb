class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/84/92/0c864272b4db3f458a130ad732720c5607a88c0f7dd09fab1ad3234a1b4f/codespell-1.15.0.tar.gz"
  sha256 "8f1bc15ca4322b72213b1cf13eb437b3c3956e0f423ab414d294d7e77e0e4130"

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", shell_output("echo teh | #{bin}/codespell -", 1)
  end
end
