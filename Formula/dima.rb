class Dima < Formula
  include Language::Python::Virtualenv

  desc "CLI to view and kill running queries in postgres"
  homepage "https://github.com/Frameio/homebrew-dima"
  url "https://github.com/Frameio/homebrew-dima/raw/master/v1.0.0.tar.gz"
  sha256 "5806856f688a3adf959f4643991b53dc7baf28975f69d7866e4307798bdc7153"
  version "1.0.0"

  depends_on "python@2"
  depends_on "postgresql"

  bottle :unneeded

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c2/f7/c7b501b783e5a74cf1768bc174ee4fb0a8a6ee5af6afa92274ff964703e0/setuptools-40.8.0.zip"
    sha256 "6e4eec90337e849ade7103723b9a99631c1f0d19990d6e8412dc42f5ae8b304d"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/36/fa/51ca4d57392e2f69397cd6e5af23da2a8d37884a605f9e3f2d3bfdc48397/pip-19.0.3.tar.gz"
    sha256 "6e6f197a1abfb45118dbb878b5c859a0edbdd33fd250100bc015b67fded4b9f2"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/b7/cf/1ea0f5b3ce55cacde1e84cdde6cee1ebaff51bd9a3e6c7ba4082199af6f6/wheel-0.33.1.tar.gz"
    sha256 "66a8fd76f28977bb664b098372daef2b27f60dc4d1688cfab7b37a09448f0e9d"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/9b/c4/4a21174f32f8a7e1104798c445dacdc1d4df86f2f26722767034e4de4bff/terminaltables-3.1.0.tar.gz"
    sha256 "f3eb0eb92e3833972ac36796293ca0906e998dc3be91fbe1f8615b331b853b81"
  end

  resource "psycopg2" do
    url "https://files.pythonhosted.org/packages/c0/07/93573b97ed61b6fb907c8439bf58f09957564cf7c39612cef36c547e68c6/psycopg2-2.7.6.1.tar.gz"
    sha256 "27959abe64ca1fc6d8cd11a71a1f421d8287831a3262bd4cacd43bbf43cc3c82"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dima", "--help"
  end
end
