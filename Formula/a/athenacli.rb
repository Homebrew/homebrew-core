class Athenacli < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for AWS Athena service"
  homepage "https://athenacli.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/31/1b/fb72060d66d8afaaba86b5ead8c4edaf4a37a2a175baa8ac391c3ee60a48/athenacli-1.7.0.tar.gz"
  sha256 "1c81f420035ae4d6ed202da659ba640982880c65c7e7755c0b5a6d25adc2ac25"
  license "BSD-3-Clause"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d1da87816be085826a1861a7f42818770c73b609ed4de18232bd4c3ecb86f7c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c732e71dc8d982a98e31783ce782db0fbe133c5c68af65aece29f33ed95c60cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "25abffd57043fbdda312668037e0899b6293969836e43f996ba27f6b0d99fc5d"
    sha256 cellar: :any,                 arm64_linux:       "791dfcb96185caa70bcbba6925e1147e015ddff772fc74fef8c778255774515c"
    sha256 cellar: :any,                 x86_64_linux:      "7478c9f88d8a5efcc336b957079ff5d12f43ab8752e601e3c77c1fda1237013e"
  end

  depends_on "python@3.15"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/a9/6e/fe973c8ce8fe4f59d6df6128600b9cc7c4ed75788bed5f5f615f88379529/boto3-1.43.110.tar.gz"
    sha256 "0251b67d99cc0e7b958db48e7dd149094d453377fcd03299fde7329f975db2e6"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/a7/d8/7a2320aabf1b1e62580e990f8a52760e396f4ec56e3ebcbce07d23acc031/botocore-1.43.110.tar.gz"
    sha256 "888cd54d59502e2195dac30805e5c08dd1be5416932a3793373e81b8f463e006"
  end

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/3f/de/278f4885fcd03661ab9b69dba9fc745c27d820858dbc06e427057899dcf5/cli_helpers-2.15.1.tar.gz"
    sha256 "e9c0826dda2855745eb63b3fd8e33b6ac8881188f2ba91e51a516ed833fc0cb8"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/77/cd/9be253869fc42e764de7f3dedd6969af7d44ff9c3375214a3442a6f3fc08/fsspec-2026.9.0.tar.gz"
    sha256 "0f08147951c8cb31d844c3547d631053b127863b60be04cf06e121333ee0e2fe"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "pyathena" do
    url "https://files.pythonhosted.org/packages/d7/d6/4b7cbbd3f68d30e05c05c9e8512c2be40f1c6583f9167b4543328630e876/pyathena-3.38.0.tar.gz"
    sha256 "55d81a4cbc3229bad3f2e3e30a243616a8626c994f4c3a864f61f7930f997589"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/15/53/5345177cafa79a49e02c27102019a01ef1682ab170d2138deca47a4c8924/Pygments-2.11.1.tar.gz"
    sha256 "59b895e326f0fb0d733fd28c6839bd18ad0687ba20efc26d4277fd1d30b971f4"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/76/43/35e4d8aa320bffe8287fe8f65f578fa2d2db0a64212f0e710dce58267854/s3transfer-0.19.2.tar.gz"
    sha256 "ba0309fd86be3c27dbf78cdd813c13c5e1df16e5874b99d2535ebbdfb9892993"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/65/16/10f170ec641ed852611b6c9441b23d10b5702ab5288371feab3d36de2574/sqlparse-0.4.4.tar.gz"
    sha256 "d446183e84b8349fa3061f0fe7f06ca94ba65b426946ffebe6e3e8295332420c"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/82/9e/497c1c8ebe5a5b5d1d4a7511aea22c0bb1a97e3170d98abdef0e1b34265a/tenacity-9.2.1.tar.gz"
    sha256 "a606b5c808d0cded4a359d5b9932d867ff2a6a6b64d37350260fd01bbdf83839"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/f0/b4/7830542634bb2d3e62aa3b586a72d5b3b6c91c3168929e7000ef3fed041d/wcwidth-0.9.2.tar.gz"
    sha256 "ae0ef90b90f6af38b54f1fe6d58662ec33b3cb4b8391958a62416d654231727b"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"athenacli", shell_parameter_format: :click)
  end

  test do
    init_run_output = shell_output("#{bin}/athenacli 2>&1", 1)
    assert_match "Welcome to athenacli!", init_run_output
    assert_match "we generated a default config file for you", init_run_output

    regular_run_output = shell_output("#{bin}/athenacli 2>&1", 1)
    assert_match "`s3_staging_dir` or `work_group` not found", regular_run_output
  end
end
