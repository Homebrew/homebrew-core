class AwscliLocal < Formula
  include Language::Python::Virtualenv

  desc "Thin wrapper around the `aws` command-line interface for use with LocalStack"
  homepage "https://www.localstack.cloud/"
  url "https://files.pythonhosted.org/packages/7a/71/591a30da6819c96deca2286f145d5982e73b11e7f657e8cbfc5e003ca73f/awscli_local-0.22.2.tar.gz"
  sha256 "07c532c372753bf5f15426451dc91d6eec9de8779748049329a9a882bdac8a0b"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "fd8d0dabd544eafb1a7f07f9d618608fe0aa8afdb16eaa89bf97044f68875ca7"
  end

  depends_on "awscli" => :test # awscli-local can work with any version of awscli
  depends_on "localstack"
  depends_on "python@3.13"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/03/2e/606fa848f0b6fb0acdcfaefed5b6c663bdb9bcf611760be3f273848d149c/boto3-1.40.14.tar.gz"
    sha256 "d1d9998fc2b9619fc796c859d263ac81793d783e79331be62931b353dd1b68b9"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/b2/1d/21d139fb01e760b7d9a527dffcd20513ab989b75837ac12b010ef11078a2/botocore-1.40.14.tar.gz"
    sha256 "1810494c8c4190f20f9e17f2da4f7ee91eda863f429c6d690ea17ec41a8f83c4"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "localstack-client" do
    url "https://files.pythonhosted.org/packages/22/11/4f10b87d634edd616d8063dd0ed1193be747e524e28801f826d72828b98f/localstack_client-2.10.tar.gz"
    sha256 "732a07e23fffd6a581af2714bbe006ad6f884ac4f8ac955211a8a63321cdc409"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/6d/05/d52bf1e65044b4e5e27d4e63e8d1579dbdec54fce685908ae09bc3720030/s3transfer-0.13.1.tar.gz"
    sha256 "c3fdba22ba1bd367922f27ec8032d6a1cf5f10c934fb5d68cf60fd5a23d936cf"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/awslocal kinesis list-streams 2>&1", 255)
    assert_match "Could not connect to the endpoint URL", output
  end
end
