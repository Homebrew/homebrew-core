class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/84/92/0c864272b4db3f458a130ad732720c5607a88c0f7dd09fab1ad3234a1b4f/codespell-1.15.0.tar.gz"
  sha256 "8f1bc15ca4322b72213b1cf13eb437b3c3956e0f423ab414d294d7e77e0e4130"

  bottle do
    cellar :any_skip_relocation
    sha256 "aae637ce9ea085bea8fb28a9efbcfd26d0c89c25a2470cdbc2eddf0d8ec21059" => :mojave
    sha256 "88380ded56e033c18878f8d7ca53988becf56ca25f4062bdb3c4e931b41a5bbd" => :high_sierra
    sha256 "9901d26d021a711e529a5e197032cddb35c8f7919054aa3953403923a992debd" => :sierra
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", shell_output("echo teh | #{bin}/codespell -", 1)
  end
end
