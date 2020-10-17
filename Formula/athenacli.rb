class Athenacli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for AWS Athena service"
  homepage "https://athenacli.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/1a/93/e97459238a4805981d4d354de5b26a043a452b32f7c832aa95237bd5dacf/athenacli-1.6.0.tar.gz"
  sha256 "f65edeb84802f4b8c7f2d89513ff126b7864e6ae04a901efb2ee1eb8471b0cb2"
  license "BSD-3-Clause"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "25b81369d3a0b6e365cbabe1ffc43cc14e806f50ac47cb2b8c8a85288b735a6f" => :catalina
    sha256 "304b38ae3ab78ce105675bec7eba3bc99314a98f06b721ed3fb8d4719a8c752c" => :mojave
    sha256 "e266f80cf2419bd52cf28ddff195689d1ccf40d0c5d9fe5fc73e5611641397ff" => :high_sierra
  end

  depends_on "python@3.9"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/ce/b8/e7fa00e5de96229964b16e766e20bbde0e055a97fc475cef7deba9036593/boto3-1.15.18.tar.gz"
    sha256 "f56148e2c6b9a2d704218da42f07d72f00270bfddb13bc1bdea20d3327daa51e"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/02/af/2fccd3e251e406429ef433f1cf1fed24da0fa527c7604db757e219aa2bbc/botocore-1.18.18.tar.gz"
    sha256 "e224754230e7e015836ba20037cac6321e8e2ce9b8627c14d579fcb37249decd"
  end

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/3f/3f/6ecd0ddf2394b698dd82ff3ddbcda235f8d6dadf124af6222eff49b32e87/cli_helpers-2.1.0.tar.gz"
    sha256 "dd6f164310f7d86fa3da1f82043a9c784e44a02ad49be932a80624261e56979b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/0c/37/7ad3bf3c6dbe96facf9927ddf066fdafa0f86766237cff32c3c7355d3b7c/prompt_toolkit-2.0.10.tar.gz"
    sha256 "f15af68f66e664eaa559d4ac8a928111eebd5feda0c11738b5998045224829db"
  end

  resource "PyAthena" do
    url "https://files.pythonhosted.org/packages/a1/52/3785de72a10021d1182d17bb27b15c548f7e1ed4fa730b5682b678c6025e/PyAthena-1.11.2.tar.gz"
    sha256 "2b4308c983c7fb27e4990932477ad3df78b7144890b74c887116b2d67c212ca6"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e2/07/25bd93c9c0175adfa5fb1513a20b25e7dd6c9a67c155e19b11b5f3662104/Pygments-2.7.1.tar.gz"
    sha256 "926c3f319eda178d1bd90851e4317e6d8cdb5e292a3386aac9bd75eca29cf9c7"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/50/de/2b688c062107942486c81a739383b1432a72717d9a85a6a1a692f003c70c/s3transfer-0.3.3.tar.gz"
    sha256 "921a37e2aefc64145e7b73d50c71bb4f26f46e4c9f414dc648c6245ff92cf7db"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/67/4b/253b6902c1526885af6d361ca8c6b1400292e649f0e9c95ee0d2e8ec8681/sqlparse-0.3.1.tar.gz"
    sha256 "e162203737712307dfe78860cc56c8da8a852ab2ee33750e33aeadf38d12c548"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/57/6f/213d075ad03c84991d44e63b6516dd7d185091df5e1d02a660874f8f7e1e/tabulate-0.8.7.tar.gz"
    sha256 "db2723a20d04bcda8522165c73eea7c300eda74e0ce852d9022e0159d7895007"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/a9/26/dfe61bbfbe7d723fe76ff41960c96161fd32ff303be88bbbdfb428250cd4/tenacity-6.2.0.tar.gz"
    sha256 "29ae90e7faf488a8628432154bb34ace1cca58244c6ea399fd33f066ac71339a"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/9b/c4/4a21174f32f8a7e1104798c445dacdc1d4df86f2f26722767034e4de4bff/terminaltables-3.1.0.tar.gz"
    sha256 "f3eb0eb92e3833972ac36796293ca0906e998dc3be91fbe1f8615b331b853b81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/81/f4/87467aeb3afc4a6056e1fe86626d259ab97e1213b1dfec14c7cb5f538bf0/urllib3-1.25.10.tar.gz"
    sha256 "91056c15fa70756691db97756772bb1eb9678fa585d9184f24534b100dc60f4a"
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
