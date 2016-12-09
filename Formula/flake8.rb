class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "http://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/51/70/af1b3130cd051f2f79854b14079b3bcbad84b8bac31a7dffc63ef57f8a7a/flake8-3.2.1.tar.gz"
  sha256 "c7c460b5aff3a2063c798a77af18ec70af3941d35a22e2e76965e3c0e0b36055"

  head "https://gitlab.com/PyCQA/flake8.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "4a77d3bae9077de0de12db93cdc041259fc9c29829ccbdbcd1067f493f1ffae0" => :sierra
    sha256 "12ffb789323a3afcab35a62e9a9b3a94dfe81d7ea0193bb9848529990850a0c0" => :el_capitan
    sha256 "3c4ebf5880732f8cd9a34577b27c5c99af3173345b4a55b893378aacc3cfbed7" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/43/9f/56e824b197398582b0c1aaaa2272560bc51f395fe3e45e1dd88de4bb24dc/pycodestyle-2.2.0.tar.gz"
    sha256 "df81dc3293e0123e2e8d1f2aaf819600e4ae287d8b3af8b72181af50257e5d9a"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/9f/48/927b1bf3e15d3dadfcfafb505177a62cdabcb78cf7eac4f31f180d5b1e26/pyflakes-1.3.0.tar.gz"
    sha256 "a4f93317c97a9d9ed71d6ecfe08b68e3de9fea3f4d94dcd1d9d83ccbf929bc31"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/f1/b7/ff36d1a163079688633a776e1717b5459caccbb68973afab2aa8345ac40f/mccabe-0.5.2.tar.gz"
    sha256 "3473f06c8b757bbb5cdf295099bf64032e5f7d6fe0ec2f97ee9b23cb0a435aff"
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
