class Jello < Formula
  include Language::Python::Virtualenv

  desc "Filter JSON and JSON Lines data with Python syntax"
  homepage "https://github.com/kellyjonbrazil/jello"
  url "https://files.pythonhosted.org/packages/6a/14/be42019984b3d701e0201b76a148103a75ddb659985a5046654f9e1a313f/jello-1.4.5.tar.gz"
  sha256 "200057e2c43184c2b3c2a707a5810f134ff9e1cfb18201eb9f2fa03fc0484501"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cf89b26555543aa7ee63d93e02df14d260fc06ba1dffb9ece2c070fadaaa6f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2cf89b26555543aa7ee63d93e02df14d260fc06ba1dffb9ece2c070fadaaa6f4"
    sha256 cellar: :any_skip_relocation, monterey:       "e1c991340147788989124b846af28bfa283dccf1af47fcdf9c03f2fd2bd0299c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1c991340147788989124b846af28bfa283dccf1af47fcdf9c03f2fd2bd0299c"
    sha256 cellar: :any_skip_relocation, catalina:       "e1c991340147788989124b846af28bfa283dccf1af47fcdf9c03f2fd2bd0299c"
    sha256 cellar: :any_skip_relocation, mojave:         "e1c991340147788989124b846af28bfa283dccf1af47fcdf9c03f2fd2bd0299c"
  end

  depends_on "python@3.10"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  def install
    virtualenv_install_with_resources
    man1.install "jello/man/jello.1"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/jello _.foo", "{\"foo\":1}")
  end
end
