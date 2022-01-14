class Principalmapper < Formula
  include Language::Python::Virtualenv

  desc "Quickly evaluate IAM permissions in AWS"
  homepage "https://github.com/nccgroup/PMapper"
  url "https://files.pythonhosted.org/packages/3f/8c/3d2efe475e9244bd45e3a776ea8207f34a9bb15caaa02f6c95e473b2ada2/principalmapper-1.1.5.tar.gz"
  sha256 "04cb9dcff0cc512df4714b3c4ea63a261001f271f95c8a453b2805290c57bbc2"
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
    url "https://files.pythonhosted.org/packages/ef/5b/3f2ccfd31ea7731c46a1fb3cfaaf7c4ed7369a77bd98cf50a7246fdb8bca/botocore-1.23.35.tar.gz"
    sha256 "5be6ba6c5ea71c256da8a5023bf9c278847c4b90fdb40f2c4c3bdb21ca11ff28"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
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
    url "https://files.pythonhosted.org/packages/ab/61/1a1613e3dcca483a7aa9d446cb4614e6425eb853b90db131c305bd9674cb/pyparsing-3.0.6.tar.gz"
    sha256 "d9bdec0013ef1eb5a84ab39a3b3868911598afa494f5faa038647101504e2b81"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b0/b1/7bbf5181f8e3258efae31702f5eab87d8a74a72a0aa78bc8c08c1466e243/urllib3-1.26.8.tar.gz"
    sha256 "0e7c33d9a63e7ddfcb86780aac87befc2fbddf46c58dbb487e0855f7ceec283c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "Account IDs:\n---", shell_output("#{bin}/pmapper graph list").strip
  end
end
