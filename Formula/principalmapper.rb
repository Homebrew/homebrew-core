class Principalmapper < Formula
  include Language::Python::Virtualenv

  desc "Quickly evaluate IAM permissions in AWS"
  homepage "https://github.com/nccgroup/PMapper"
  url "https://files.pythonhosted.org/packages/11/eb/497f5f0229de52744aa4af6874e32db9728ba0d461a08b65456d358a9928/principalmapper-1.1.3.tar.gz"
  sha256 "2b0bedca0b9b397ec455ba20c1576fb5e35ba4f57b87f29fc3a527da6aeae52d"
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
    url "https://files.pythonhosted.org/packages/29/56/64570ac92c7cb88ad731dea4da4a83d3edc9f00a13a969ad826354ba5a58/botocore-1.20.111.tar.gz"
    sha256 "21fc74dba0d4d6297b322aa79ecb4476b9e03a84b3f38eee2bed47555f4b4013"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/86/aef78bab3afd461faecf9955a6501c4999933a48394e90f03cd512aad844/packaging-21.0.tar.gz"
    sha256 "7dc96269f53a4ccec5c0670940a4281106dd0bb343f47b7471f779df49c2fbe7"
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
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "Account IDs:\n---", shell_output("#{bin}/pmapper graph list").strip
  end
end
