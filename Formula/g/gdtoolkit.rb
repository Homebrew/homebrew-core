class Gdtoolkit < Formula
  include Language::Python::Virtualenv

  desc "Independent set of GDScript tools - parser, linter, formatter, and more"
  homepage "https://github.com/Scony/godot-gdscript-toolkit"
  url "https://files.pythonhosted.org/packages/5e/71/0563b7f812c4db67ead1d47cf6710c3e9c6e1a7d505321240efc7638c08b/gdtoolkit-4.3.3.tar.gz"
  sha256 "f17089c3e33d0053ab229a637a9faabc0fb8ebb07412fe719ed00b2e66adc343"
  license "MIT"

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "docopt-ng" do
    url "https://files.pythonhosted.org/packages/e4/50/8d6806cf13138127692ae6ff79ddeb4e25eb3b0bcc3c1bd033e7e04531a9/docopt_ng-0.9.0.tar.gz"
    sha256 "91c6da10b5bb6f2e9e25345829fb8278c78af019f6fc40887ad49b060483b1d7"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/af/60/bc7622aefb2aee1c0b4ba23c1446d3e30225c8770b38d7aedbfb65ca9d5a/lark-1.2.2.tar.gz"
    sha256 "ca807d0162cd16cef15a8feecb862d7319e7a09bdb13aef927968e45040fed80"
  end

  resource "mando" do
    url "https://files.pythonhosted.org/packages/35/24/cd70d5ae6d35962be752feccb7dca80b5e0c2d450e995b16abd6275f3296/mando-0.7.1.tar.gz"
    sha256 "18baa999b4b613faefb00eac4efadcf14f510b59b924b66e08289aa1de8c3500"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "radon" do
    url "https://files.pythonhosted.org/packages/b1/6d/98e61600febf6bd929cf04154537c39dc577ce414bafbfc24a286c4fa76d/radon-6.0.1.tar.gz"
    sha256 "d1ac0053943a893878940fedc8b19ace70386fc9c9bf0a09229a44125ebf45b5"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/ac/57/e6f0bde5a2c333a32fbcce201f906c1fd0b3a7144138712a5e9d9598c5ec/setuptools-75.7.0.tar.gz"
    sha256 "886ff7b16cd342f1d1defc16fc98c9ce3fde69e087a4e1983d7ab634e5f41f4f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"gdformat", "--version"
    system bin/"gdparse", "--version"
    system bin/"gdlint", "--version"
    system bin/"gdradon", "--version"
  end
end
