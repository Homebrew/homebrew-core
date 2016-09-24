class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "http://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/b0/56/48727b2a6c92b7e632180cf2c1411a0de7cf4f636b4f844c6c46f7edc86b/flake8-3.0.4.tar.gz"
  sha256 "b4c210c998f07d6ff24325dd91fbc011f2c37bcd6bf576b188de01d8656e970d"

  head "https://gitlab.com/PyCQA/flake8.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "5365ccde15ef180a29bce52c527d066055ef3d37ad97d98c7981503ee3c09822" => :el_capitan
    sha256 "3a056046b54e37f52570660725f9b95c54b27644f6414b6d803d215d4a6c6d57" => :yosemite
    sha256 "4a39db554b676640dcac0c8b834b78bd7f58155a1bede9b300cd5fee5824f224" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/db/b1/9f798e745a4602ab40bf6a9174e1409dcdde6928cf800d3aab96a65b1bbf/pycodestyle-2.0.0.tar.gz"
    sha256 "37f0420b14630b0eaaf452978f3a6ea4816d787c3e6dcbba6fb255030adae2e7"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/54/80/6a641f832eb6c6a8f7e151e7087aff7a7c04dd8b4aa6134817942cdda1b6/pyflakes-1.2.3.tar.gz"
    sha256 "2e4a1b636d8809d8f0a69f341acf15b2e401a3221ede11be439911d23ce2139e"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/57/fa/4a0cda4cf9877d2bd12ab031ae4ecfdc5c1bbb6e68f3fe80da4f29947c2a/mccabe-0.5.0.tar.gz"
    sha256 "379358498f58f69157b53f59f46aefda0e9a3eb81365238f69fbedf7014e21ab"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/7c/69/c2ce7e91c89dc073eb1aa74c0621c3eefbffe8216b3f9af9d3885265c01c/configparser-3.5.0.tar.gz"
    sha256 "5308b47021bc2340965c371f0f058cc6971a04502638d4244225c49d80db273a"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/flake8", "#{libexec}/lib/python2.7/site-packages/flake8"
  end
end
