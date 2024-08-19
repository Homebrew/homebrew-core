class EcsDeploy < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to simplify Amazon ECS deployments, rollbacks & scaling"
  homepage "https://github.com/fabfuel/ecs-deploy"
  url "https://files.pythonhosted.org/packages/f1/3c/a2fc74f43992bda8df2e159351c254bacb5c157e766698b9aa537d459c7e/ecs-deploy-1.15.0.tar.gz"
  sha256 "9fbd007e62b8842c3e82e80e1531af157eda8236d2822512170c62430c669ad3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f70502bc919d266ec26287a517f385675c465b34862a2d00f15d73848e9526ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f70502bc919d266ec26287a517f385675c465b34862a2d00f15d73848e9526ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f70502bc919d266ec26287a517f385675c465b34862a2d00f15d73848e9526ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "f70502bc919d266ec26287a517f385675c465b34862a2d00f15d73848e9526ba"
    sha256 cellar: :any_skip_relocation, ventura:        "f70502bc919d266ec26287a517f385675c465b34862a2d00f15d73848e9526ba"
    sha256 cellar: :any_skip_relocation, monterey:       "f70502bc919d266ec26287a517f385675c465b34862a2d00f15d73848e9526ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfbc4a97ca89ced505c472b547c372c8019212b85ea0910f72f35fe1e6db7822"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/94/42/f34ab93ea175b4e6c96e73a3b3f24d073f63418971925c8149d41f6a252a/boto3-1.34.136.tar.gz"
    sha256 "0314e6598f59ee0f34eb4e6d1a0f69fa65c146d2b88a6e837a527a9956ec2731"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/3c/ec/09d963aa91a1d09a87c21c014da5092a1eccde8b44cd51bbe8a27e3576fd/botocore-1.34.136.tar.gz"
    sha256 "7f7135178692b39143c8f152a618d2a3b71065a317569a7102d2306d4946f42f"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-log" do
    url "https://files.pythonhosted.org/packages/22/44/3d73579b547f0790a2723728088c96189c8b52bd2ee3c3de8040efc3c1b8/click-log-0.3.2.tar.gz"
    sha256 "16fd1ca3fc6b16c98cea63acf1ab474ea8e676849dc669d86afafb0ed7003124"
  end

  resource "dictdiffer" do
    url "https://files.pythonhosted.org/packages/61/7b/35cbccb7effc5d7e40f4c55e2b79399e1853041997fcda15c9ff160abba0/dictdiffer-0.9.0.tar.gz"
    sha256 "17bacf5fbfe613ccf1b6d512bd766e6b21fb798822a133aa86098b8ac9997578"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/a7/b2/4140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3ba/future-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/4c/d2/70fc708727b62d55bc24e43cc85f073039023212d482553d853c44e57bdb/requests-2.29.0.tar.gz"
    sha256 "f2e34a75f4749019bb0e3effb66683630e4ffeaf75819fb51bebef1bf5aef059"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/cb/67/94c6730ee4c34505b14d94040e2f31edf144c230b6b49e971b4f25ff8fab/s3transfer-0.10.2.tar.gz"
    sha256 "0711534e9356d3cc692fdde846b4a1e4b0cb6519971860796e6bc4c7aea00ef6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c8/93/65e479b023bbc46dab3e092bda6b0005424ea3217d711964ccdede3f9b1b/urllib3-1.26.19.tar.gz"
    sha256 "3e3d753a8618b86d7de333b4223005f68720bcd6a7d2bcb9fbd2229ec7c1e429"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"
    ENV["AWS_DEFAULT_REGION"] = "us-east-1"

    output = shell_output("#{bin}/ecs run TEST_CLUSTER TEST_TASK 2>&1", 1)
    assert_match "Unknown task definition arn: TEST_TASK", output

    assert_match version.to_s, shell_output("#{bin}/ecs --version")
  end
end
