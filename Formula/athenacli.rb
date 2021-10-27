class Athenacli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for AWS Athena service"
  homepage "https://athenacli.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/c0/12/0d2afd21f75b4966d0327769f561ec0006fe819c02d84f5e4b348e4e7417/athenacli-1.6.2.tar.gz"
  sha256 "8b9b22e3ca465bde607e2346c7df7940d8c5750a450de5a8e6362882176de390"
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
    url "https://files.pythonhosted.org/packages/99/a1/38f33364bc56d089e341032811df8c201906dd4032a5985119f5acafa9a8/boto3-1.18.1.tar.gz"
    sha256 "ddfe4a78f04cd2d3a7a37d5cdfa07b4889b24296508786969bc968bee6b8b003"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/66/5c/b88bc63c2b50965abd68abdd9f65b2d58a4d815e46be725a66027e610d37/botocore-1.21.1.tar.gz"
    sha256 "200887ce5f3b47d7499b7ded75dc65c4649abdaaddd06cebc118a3a954d6fd73"
  end

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/3f/3f/6ecd0ddf2394b698dd82ff3ddbcda235f8d6dadf124af6222eff49b32e87/cli_helpers-2.1.0.tar.gz"
    sha256 "dd6f164310f7d86fa3da1f82043a9c784e44a02ad49be932a80624261e56979b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
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
    url "https://files.pythonhosted.org/packages/99/c8/2693220ee07c5f3e9a3af66399afae3da1771fcc82a052c6363adf0e17aa/PyAthena-2.3.0.tar.gz"
    sha256 "856afea495efd5b8e8c80cc06e6e4c9e77e662898aed1f528a787be54731d421"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
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

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/9b/c4/4a21174f32f8a7e1104798c445dacdc1d4df86f2f26722767034e4de4bff/terminaltables-3.1.0.tar.gz"
    sha256 "f3eb0eb92e3833972ac36796293ca0906e998dc3be91fbe1f8615b331b853b81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
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
