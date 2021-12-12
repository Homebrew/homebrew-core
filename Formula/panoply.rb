class Panoply < Formula
  include Language::Python::Virtualenv

  desc "Save your commands and reuse them"
  homepage "https://github.com/jeremynac/panoply"
  url "https://files.pythonhosted.org/packages/cd/0e/0f1941eddb73b39c969f5ea17891593e83b3877f0a67049a2ffdb0fd6736/panoply-0.1.45.tar.gz"
  sha256 "d8f5d2241da0294e47fdbde12ef140b4c87599b752d30e187ed977712919cafc"

  depends_on 'python@3.9'

  resource "simple-term-menu" do
    url "https://files.pythonhosted.org/packages/de/08/08c19f7653a9d7c73df024090243a8a44583b613f8f1ed51d79cbb5ae70e/simple-term-menu-1.4.1.tar.gz"
    sha256 "401e7efc6726e195b8e62bfcede51298dc0daf8c5f043a521c8828191b0b012e"
  end

  def install
    virtualenv_create(libexec, "python@3.9")
    virtualenv_install_with_resources
  end

  test do
    assert_match "There are no commands saved yet\n\
    usage: panoply [-h] [-a] [-r]\n\
    \n\
    Save your commands and reuse them\
    \n\
    optional arguments:\n\
      -h, --help    show this help message and exit\n\
      -a, --add     add a command\n\
      -r, --remove  remove a command\n", shell_output(bin/"panoply")
  end
end
