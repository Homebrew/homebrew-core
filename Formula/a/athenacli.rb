class Athenacli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for AWS Athena service"
  homepage "https://athenacli.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/38/1a/d9cd6c68a4a1cd2ce779b163f8cec390ae82c684caa920d0360094886b1f/athenacli-1.6.8.tar.gz"
  sha256 "c7733433f2795d250e3c23b134136fea571ea9868c15f424875cd194eaeb7246"
  license "BSD-3-Clause"
  revision 4

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2ad6929c534f32c8926c7028787b922fca4be385a758d4304501a8ba8df88bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d821fa1c99abe247a6c2c48870ed533b2625fe26787c694a8298ddbd798501f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "088b3a993eced636a992925a6d35f93a45332abb04a8798d61d41d2734d7f14c"
    sha256 cellar: :any_skip_relocation, sonoma:         "709781d8d2aaa0be96e7c0ad503a32a59cba9c505740913aeb15622b965c50bc"
    sha256 cellar: :any_skip_relocation, ventura:        "204ec2e7a9220ae96485f2f412710c8ec8c451dd7fff8bb9d62d53d0e6250c07"
    sha256 cellar: :any_skip_relocation, monterey:       "e223ce1cad2882bf2d4c5f868f477bda7b5d3e1b1e84a7e8fc2cf8be2d038c4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee058ac64120c21d9ffd91d85cf501192eff0bddd2c39c6217ac90a0b4cfca67"
  end

  depends_on "python@3.12"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/01/73/b02f13ba277993c4b0f237d78bfa572b0ee06483e685140118b004b1d76e/boto3-1.34.46.tar.gz"
    sha256 "eb5d84c2127ffddf8e7f4dd6f9084f86cb18dca8416fb5d6bea278298cf8d84c"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/4a/2b/c62910b4c6983394590fddc46d0b3a44b4fcb726a0c1428cd56b92482241/botocore-1.34.46.tar.gz"
    sha256 "21a6c391c6b4869aed66bc888b8e6d54581b343514cfe97dbe71ede12026c3cc"
  end

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/ab/de/79529bd31c1664415d9554c0c5029f2137afe9808f35637bbcca977d9022/cli_helpers-2.3.1.tar.gz"
    sha256 "b82a8983ceee21f180e6fd0ddb7ca8dae43c40e920951e3817f996ab204dae6a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/28/d3/c2e0403c735548abf991bba3f45ba39194dff4569f76a99fbe77078ba7c5/fsspec-2024.2.0.tar.gz"
    sha256 "b6ad1a679f760dda52b1168c859d01b7b80648ea6f7f7c7f5a8a91dc3f3ecb84"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/cc/c6/25b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126ca/prompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "pyathena" do
    url "https://files.pythonhosted.org/packages/02/83/08cddc05d95f4dc4abf4702be18fd2775336a2c2f474baf4a698f73f4f6f/pyathena-3.3.0.tar.gz"
    sha256 "dd2e6241e99b85a43531cc40272644806d33eb44b95211161afec1b496e43d37"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/15/53/5345177cafa79a49e02c27102019a01ef1682ab170d2138deca47a4c8924/Pygments-2.11.1.tar.gz"
    sha256 "59b895e326f0fb0d733fd28c6839bd18ad0687ba20efc26d4277fd1d30b971f4"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/a0/b5/4c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40ba/s3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/65/16/10f170ec641ed852611b6c9441b23d10b5702ab5288371feab3d36de2574/sqlparse-0.4.4.tar.gz"
    sha256 "d446183e84b8349fa3061f0fe7f06ca94ba65b426946ffebe6e3e8295332420c"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/89/3c/253e1627262373784bf9355db9d6f20d2d8831d79f91e9cca48050cddcc2/tenacity-8.2.3.tar.gz"
    sha256 "5398ef0d78e63f40007c1fb4c0bff96e1911394d2fa8d194f77619c05ff6cc8a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
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
