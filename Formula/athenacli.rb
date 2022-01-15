class Athenacli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for AWS Athena service"
  homepage "https://athenacli.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/26/6b/b1a48849e26805db63b556da9ff6db3abb2287c5924cceb29ac0028ccce0/athenacli-1.6.3.tar.gz"
  sha256 "e372334e82ae8596823df216dbdaf431ddf7a339d1c6a972bb5933bef5f217a4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d24f688287b0a0f4690f9a36d32f43894bab52be3235cbb7fa5c44124fb352cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d4e180606a383f5a429b747907adc7b72de838df9e58eac6bc8154b1001e684"
    sha256 cellar: :any_skip_relocation, monterey:       "c89282cd2a1d81c26a105193c8c86c487311d6abe328a7596c88e1eb8d0c9d65"
    sha256 cellar: :any_skip_relocation, big_sur:        "d43f42a51da85ec3114efdf5ce341f0346b794727cc50ea7017479adefa70c3c"
    sha256 cellar: :any_skip_relocation, catalina:       "5cc0c045ac8647ee56979aabe866f1e37eba10019efc024629e60351e288778f"
    sha256 cellar: :any_skip_relocation, mojave:         "e70a30579f8117f055d615c60b0355b874cfcf14f64d98c01db55531c515161e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "287d464dee3ab519abef5f31abd59817c9027a2aebc52b52579ee36b99f838c1"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/9e/23/a5d5fcc735d8f528df0571cba4c50b57a7ddd0889e6f4d4cdd2c33cb308f/boto3-1.20.36.tar.gz"
    sha256 "d2df801e368ec0782c6ed50232dd76bf0ae38ef63056d8d363a39bad62947166"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/61/38/df485d4c1e5f8f67346f3366cc3bf5982653a6f5c161d3f55c2ee9ffd0ab/botocore-1.23.36.tar.gz"
    sha256 "3af8fef31baae5cc4016dadcb4cf7848a0bf1efb74bcdb7d1dc6b8d0910e1898"
  end

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/86/ed/eb0468849a425a9ef0d15f789e2272bb5fc4081926f0261542927599177b/cli_helpers-2.2.0.tar.gz"
    sha256 "733f65d8c921e0cffa8f7ae4c8735bd7ecdffec383c5246f647ddd0fddb33448"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/0c/37/7ad3bf3c6dbe96facf9927ddf066fdafa0f86766237cff32c3c7355d3b7c/prompt_toolkit-2.0.10.tar.gz"
    sha256 "f15af68f66e664eaa559d4ac8a928111eebd5feda0c11738b5998045224829db"
  end

  resource "pyathena" do
    url "https://files.pythonhosted.org/packages/c1/a7/4c2a72db039b953aead26c070c0c9feedcce797c4f6b74d9b0d5c978437a/PyAthena-2.3.2.tar.gz"
    sha256 "20a473c52e76a211c427d2f711af0a04804a70fc036ab884780e42e0dc2025f7"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/15/53/5345177cafa79a49e02c27102019a01ef1682ab170d2138deca47a4c8924/Pygments-2.11.1.tar.gz"
    sha256 "59b895e326f0fb0d733fd28c6839bd18ad0687ba20efc26d4277fd1d30b971f4"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/88/ef/4d1b3f52ae20a7e72151fde5c9f254cd83f8a49047351f34006e517e1655/s3transfer-0.5.0.tar.gz"
    sha256 "50ed823e1dc5868ad40c8dc92072f757aa0e653a192845c94a3b676f4a62da4c"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/67/4b/253b6902c1526885af6d361ca8c6b1400292e649f0e9c95ee0d2e8ec8681/sqlparse-0.3.1.tar.gz"
    sha256 "e162203737712307dfe78860cc56c8da8a852ab2ee33750e33aeadf38d12c548"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/2c/f5/04748914f5c78f7418b803226bd56cdddd70ac369b936b3e24f5158017f1/tenacity-8.0.1.tar.gz"
    sha256 "43242a20e3e73291a28bcbcacfd6e000b02d3857a9a9fff56b297a27afdc932f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b0/b1/7bbf5181f8e3258efae31702f5eab87d8a74a72a0aa78bc8c08c1466e243/urllib3-1.26.8.tar.gz"
    sha256 "0e7c33d9a63e7ddfcb86780aac87befc2fbddf46c58dbb487e0855f7ceec283c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    init_run_output = shell_output("#{bin}/athenacli 2>&1", 1)
    assert_match "Welcome to athenacli!", init_run_output
    assert_match "we generated a default config file for you", init_run_output

    regular_run_output = shell_output("#{bin}/athenacli 2>&1", 1)
    assert_match "`s3_staging_dir` or `work_group` not found", regular_run_output
  end
end
