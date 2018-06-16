class Jsdaily < Formula
  include Language::Python::Virtualenv

  desc "Some useful daily utility scripts"
  homepage "https://github.com/JarryShaw/jsdaily#jsdaily"
  url "https://files.pythonhosted.org/packages/a1/11/7e8b6ac67a9daab4a6c41ef19af0377e3801f51816c7ad176af6f26605a4/jsdaily-1.1.1.post2.tar.gz"
  sha256 "f63c3af41d157d3a0d5a79a2d79982368435af9e27e779ca1e2bf029d8f19b42"
  head "https://github.com/JarryShaw/jsdaily.git"

  depends_on "python3"

  # resource "setuptools" do
  #   url "https://files.pythonhosted.org/packages/1a/04/d6f1159feaccdfc508517dba1929eb93a2854de729fa68da9d5c6b48fa00/setuptools-39.2.0.zip"
  #   sha256 "f7cddbb5f5c640311eb00eab6e849f7701fa70bf6a183fc8a2c33dd1d1672fb2"
  # end

  resource "pipdeptree" do
    url "https://files.pythonhosted.org/packages/77/e3/0d11974aebed93bf9b12a43c8a8494ed1c40ea2084304e8a6b26d48c4fcf/pipdeptree-0.12.1.tar.gz"
    sha256 "6683e1779d15828cf42f269e168a3f8559aef28a0c176d5ed85b50cd46634078"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  # def post_install
  #   # some post install scripts
  # end

  test do
    system bin/"jsdaily", "update", "--all"
  end
end
