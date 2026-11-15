class AwscliLocal < Formula
  include Language::Python::Virtualenv

  desc "Thin wrapper around the `aws` command-line interface for use with LocalStack"
  homepage "https://www.localstack.cloud/"
  url "https://files.pythonhosted.org/packages/b1/56/fb8eed90e00285f34ba97239c94c63daa963ce1746d2a99b2f66b893ba92/awscli_local-0.23.0.tar.gz"
  sha256 "59aa31190d578967a4d376440320810e00ffd7dabba5dcb9eab6ae7a4c633441"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f557d0e00332505ee16042189fdeeec8dfea4ba3a4eb1c5a9b03d6793072d609"
  end

  depends_on "awscli" => :test # awscli-local can work with any version of awscli
  depends_on "python@3.15"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/cc/20/de5848b0166d8cb6b6e597b299ca10a64ebba3cf9aaab228de1e817ae85e/boto3-1.43.116.tar.gz"
    sha256 "89fa15e7d1788fb17cbd694b034beba57f43f30f58f4506913a5b62220f8ba01"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/93/98/aff05e8a35f5bb9f6648c6056ecff02a2bd4540ad70a89215db8a0cae758/botocore-1.43.116.tar.gz"
    sha256 "00b1fbfc1c024b56633538385628a1bbc7ab15aca0b5b53e5fe188841d96c8ce"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "localstack-client" do
    url "https://files.pythonhosted.org/packages/88/99/f0cb24bd7687765f37ce6a577736a4a13501054be66eb748ddd4a13e6592/localstack_client-2.12.tar.gz"
    sha256 "dbb98712fd2c8869d5dfed7a2ca006b95c7750fe9a43af123ef054efc7e7ebb4"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/49/c5/0a5ce655109cb96b8dfad36908a4e108d15f5dc2eff8fbc3146c4312e704/s3transfer-0.19.3.tar.gz"
    sha256 "8326acc3d056d7f7b8a37110c7d2aea41f67e83f6ae79cd3b5fbcca34c726406"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  allow_network_access! :build

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/awslocal kinesis list-streams 2>&1", 255)
    assert_match "Could not connect to the endpoint URL", output
  end
end
