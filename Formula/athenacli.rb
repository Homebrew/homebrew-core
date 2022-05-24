class Athenacli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for AWS Athena service"
  homepage "https://athenacli.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/38/1a/d9cd6c68a4a1cd2ce779b163f8cec390ae82c684caa920d0360094886b1f/athenacli-1.6.8.tar.gz"
  sha256 "c7733433f2795d250e3c23b134136fea571ea9868c15f424875cd194eaeb7246"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "612fbf2fee22c4c519962861dd862c90a5244e66810afb79726dd2c4a7aa5f21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7b790adebc0fcf8ef135b50869c365aad0f40775c836886e5cb0bcf512939bb"
    sha256 cellar: :any_skip_relocation, monterey:       "3100b6a04e1bd70319f825b8d6f1029ac74633b9eb82245a58e0f2635cc7c82f"
    sha256 cellar: :any_skip_relocation, big_sur:        "425ed8802ae34f2dfc7ceea9b843784f933a53c2c3cf6e05848adbf44a0902f2"
    sha256 cellar: :any_skip_relocation, catalina:       "d5c23122a70120716e19235afdb869590676c047ce3d0702149b4581f590a808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c74df7b94d58e4e2e034ba51d6971f3619103fdd203126c13f737956f7676c1"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/9a/e0/f677cd783efcf025660cad862228b9d72de2f2f02f7485dfbaa54ac31551/boto3-1.23.0.tar.gz"
    sha256 "07c4d128cb625f9459af8b6dff65ad9c3475e3b186f81c0e57af3d563d933cbd"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/d7/35/7566590ed0272ef057d2e34ddbe8290451842ddacf3c802b14751f60fb8d/botocore-1.26.0.tar.gz"
    sha256 "4c7ae9198ffbe1a834fd3928d2e6a4c68250c0d9f82e70c32b652d3525bec9c3"
  end

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/d9/5d/bd0b08f7f8f9d02f44055cf4b41aafa658c1b0731237f303b9fdb49fc8d7/cli_helpers-2.2.1.tar.gz"
    sha256 "0ccc1cfcda1ac64dc7ed83d7013055cf19e5979d29e56c21f3b692de01555aae"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/06/7e/44686b986ef9ca6069db224651baaa8300b93af2a085a5b135997bf659b3/jmespath-1.0.0.tar.gz"
    sha256 "a490e280edd1f57d6de88636992d05b71e97d69a26a19f058ecf7d304474bf5e"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/59/68/4d80f22e889ea34f20483ae3d4ca3f8d15f15264bcfb75e52b90fb5aefa5/prompt_toolkit-3.0.29.tar.gz"
    sha256 "bd640f60e8cecd74f0dc249713d433ace2ddc62b65ee07f96d358e0b152b6ea7"
  end

  resource "pyathena" do
    url "https://files.pythonhosted.org/packages/68/5f/abc84427909a075c66a102fe8a76ef2af6cb86fc6189ef0c36e58c1093a7/PyAthena-2.7.0.tar.gz"
    sha256 "12bcff2c838a9fcfbd038f887a515bea5188770270c2459b5bd10a4a9e07484e"
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
    url "https://files.pythonhosted.org/packages/7e/19/f82e4af435a19b28bdbfba63f338ea20a264f4df4beaf8f2ab9bfa34072b/s3transfer-0.5.2.tar.gz"
    sha256 "95c58c194ce657a5f4fb0b9e60a84968c808888aed628cd98ab8771fe1db98ed"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/32/fe/8a8575debfd924c8160295686a7ea661107fc34d831429cce212b6442edb/sqlparse-0.4.2.tar.gz"
    sha256 "0c00730c74263a94e5a9919ade150dfc3b19c574389985446148402998287dae"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/2c/f5/04748914f5c78f7418b803226bd56cdddd70ac369b936b3e24f5158017f1/tenacity-8.0.1.tar.gz"
    sha256 "43242a20e3e73291a28bcbcacfd6e000b02d3857a9a9fff56b297a27afdc932f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
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
