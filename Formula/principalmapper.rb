class Principalmapper < Formula
  include Language::Python::Virtualenv

  desc "Quickly evaluate IAM permissions in AWS"
  homepage "https://github.com/nccgroup/PMapper"
  url "https://files.pythonhosted.org/packages/b4/4d/c270b88e05d4b17705936b7a3d05056d67e117b4087c663834d9bbd348d6/principalmapper-1.1.2.tar.gz"
  sha256 "e36366a603b812de9eaf9c242a421f6982517b236344b9c44a1c509d82c62a26"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3ec153451b85c2516e5c6176af999210c02cd4ac8a4fd81838d4d7e0443949aa"
    sha256 cellar: :any_skip_relocation, big_sur:       "6b28c5a692ad3d4afc483552caacba94b7d9efc61855b6b89c87454b9e13b493"
    sha256 cellar: :any_skip_relocation, catalina:      "3d61aeb9896b56bd45befa05ee6c209858088e2630b90360678ed392970299a6"
    sha256 cellar: :any_skip_relocation, mojave:        "f66592208c17fe6ebfcb0ae0d2b43f5f9b248212a149f1c194b58c642e93c18a"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/03/f3/99f57f59a101268612dd11ae4d34f3ed725394c327f28a94d2be6a510f63/botocore-1.20.84.tar.gz"
    sha256 "bc59eb748fcb07835613ebea6dcc2600ae1a8be0fae30e40b9c1e81b73262296"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/13/6e/916cdf94f9b38ae0777b254c75c3bdddee49a54cc4014aac1460a7a172b3/pydot-1.4.2.tar.gz"
    sha256 "248081a39bcb56784deb018977e428605c1c758f10897a339fce1dd728ff007d"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/94/40/c396b5b212533716949a4d295f91a4c100d51ba95ea9e2d96b6b0517e5a5/urllib3-1.26.5.tar.gz"
    sha256 "a7acd0977125325f516bda9735fa7142b909a8d01e8b2e4c8108d0984e6e0098"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "Account IDs:\n---", shell_output("#{bin}/pmapper graph list").strip
  end
end
