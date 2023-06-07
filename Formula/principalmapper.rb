class Principalmapper < Formula
  include Language::Python::Virtualenv

  desc "Quickly evaluate IAM permissions in AWS"
  homepage "https://github.com/nccgroup/PMapper"
  url "https://files.pythonhosted.org/packages/3f/8c/3d2efe475e9244bd45e3a776ea8207f34a9bb15caaa02f6c95e473b2ada2/principalmapper-1.1.5.tar.gz"
  sha256 "04cb9dcff0cc512df4714b3c4ea63a261001f271f95c8a453b2805290c57bbc2"
  license "AGPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0b0609b68206f01b9f0b420831e9e303d9dd9e97dd6989222d13307c16f18fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40db4bf177682d1efe58ce309aeb052b2d04b3bfda841529f3711f89cce15971"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad1ea1e603edfa2278847f70e194565c883c4feeb3d47f6b5ae19fd54c08d33c"
    sha256 cellar: :any_skip_relocation, ventura:        "fc7b301326ce7f99cc5ef04ef0690fe57960b5f114a4b5674ed3eddaa7202511"
    sha256 cellar: :any_skip_relocation, monterey:       "cceceaa1b6018b7e539ab6d539cb1733040b951430abcfe85fff61059f9a44d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7d9626874aa2df94cd4c3763ff45d3a51ac174be3ae6b7304e352107c51df50"
    sha256 cellar: :any_skip_relocation, catalina:       "571811598116caf816bd85365e15524bacb44b06fec98777505db53ee0c0b191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b881af0513ff8953dc5ef5f8d7fcf18ffad7b90c1186a32779c5aa438b62938"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/61/d0/864d19810c779c8f2cc4e64030414c2056178863c6a61d2f831ab031cc35/botocore-1.29.3.tar.gz"
    sha256 "ac7986fefe1b9c6323d381c4fdee3845c67fa53eb6c9cf586a8e8a07270dbcfe"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/13/6e/916cdf94f9b38ae0777b254c75c3bdddee49a54cc4014aac1460a7a172b3/pydot-1.4.2.tar.gz"
    sha256 "248081a39bcb56784deb018977e428605c1c758f10897a339fce1dd728ff007d"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  # Support Python 3.10, remove on next release
  patch do
    url "https://github.com/nccgroup/PMapper/commit/88bad89bd84a20a264165514363e52a84d39e8d7.patch?full_index=1"
    sha256 "9c731e2613095ea5098eda7141ae854fceec3fc8477a7a7e3202ed6c751e68dc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "Account IDs:\n---", shell_output("#{bin}/pmapper graph list").strip
  end
end
