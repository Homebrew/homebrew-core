class Principalmapper < Formula
  include Language::Python::Virtualenv

  desc "Quickly evaluate IAM permissions in AWS"
  homepage "https://github.com/nccgroup/PMapper"
  url "https://files.pythonhosted.org/packages/89/d9/985cfe5c571a27f9933af49c5dd07752586200e104060106ac6937f6bb98/principalmapper-1.1.4.tar.gz"
  sha256 "742b537c09fac2361cde6465a2408f2390ce9af2c90d1174d645c8d13f72eab5"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57a540d7c14d58a06b4801aac59ee591571d4d9183134ee8c31cd5f9a7416ba7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70c568a9c38cac05d9322b896eee1242e595ee249ced25bfbf7f59a04da4d88b"
    sha256 cellar: :any_skip_relocation, monterey:       "fb97ef56f0680a894e98b0602dbb5080fc73503e01a41322f48d400770072981"
    sha256 cellar: :any_skip_relocation, big_sur:        "10f7fa907a504870d8111c9c6ea3deab55eb8bce87ec7689b22b9a0a18910d17"
    sha256 cellar: :any_skip_relocation, catalina:       "7dd91fb6b983f5f4c5a4b56143b22c0def678278ec00b422f15c783a967da5c6"
    sha256 cellar: :any_skip_relocation, mojave:         "4d10def939d3034a6c6aece9ba80ba596ac9ed73afb7417ed157ee3df5b9bced"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/0e/db/4ed8004ba94ef2173b943fc644d0e0f715631df1e40c5d60edf5c83d54eb/botocore-1.21.58.tar.gz"
    sha256 "87e881569c32b218a1b82ecb607a4dddb4dca3b80a5d1016571b99b51cef3158"
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
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "Account IDs:\n---", shell_output("#{bin}/pmapper graph list").strip
  end
end
