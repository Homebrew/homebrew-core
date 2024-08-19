class Parliament < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM linting library"
  homepage "https://github.com/duo-labs/parliament"
  url "https://files.pythonhosted.org/packages/a6/3f/b7262b8a7c8d41c243950c5858cefc29652623599a6fafb2f753621b9702/parliament-1.6.3.tar.gz"
  sha256 "13e0f21048c3f2f6dbc3e90035421a7f2e35eda55c829794ec3f410140ce6740"
  license "BSD-3-Clause"
  head "https://github.com/duo-labs/parliament.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9f2be989f303519fb28ad485bdbc4c585fd4ee24f2316a57849b4d2fa1451ae7"
    sha256 cellar: :any,                 arm64_ventura:  "836145ee2f4070d875c8e43425b47388eb10c5df47ad95368cd98e8886614fc0"
    sha256 cellar: :any,                 arm64_monterey: "c04fe7a13b8123c5f2268055c2b09566a1f75ca9df262015a6b4366deaacc08f"
    sha256 cellar: :any,                 sonoma:         "2679c58cae8562f532271a2dbc7697afa65de343183b559a2732e805199180da"
    sha256 cellar: :any,                 ventura:        "6ff4d248bed9023bca41479ff5f45485d7b891df2b64678cc45e8c1fc5aa0571"
    sha256 cellar: :any,                 monterey:       "e85a8e4e086f6d420234ec861a0099f2b08287abe8daef7ad65f509d279241e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65816d2a5d4d0f190795261b67e8498edeb7ed353337fd4c74f5b9bfefdf242a"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/96/40/c8d85f14e0aea7b80859595fadad5ad80f6662ac78f150d844c4e25fe90b/boto3-1.34.149.tar.gz"
    sha256 "f4e6489ba9dc7fb37d53e0e82dbc97f2cb0a4969ef3970e2c88b8f94023ae81a"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/33/cb/acc65294eb572c83cec1d25cc637fb82745a7b40e69680a09855ee397b49/botocore-1.34.149.tar.gz"
    sha256 "2e1eb5ef40102a3d796bb3dd05f2ac5e8fb43fe1ff114b4f6d33153437f5a372"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "json-cfg" do
    url "https://files.pythonhosted.org/packages/70/d8/34e37fb051be7c3b143bdb3cc5827cb52e60ee1014f4f18a190bb0237759/json-cfg-0.4.2.tar.gz"
    sha256 "d3dd1ab30b16a3bb249b6eb35fcc42198f9656f33127e36a3fadb5e37f50d45b"
  end

  resource "kwonly-args" do
    url "https://files.pythonhosted.org/packages/ee/da/a7ba4f2153a536a895a9d29a222ee0f138d617862f9b982bd4ae33714308/kwonly-args-1.0.10.tar.gz"
    sha256 "59c85e1fa626c0ead5438b64f10b53dda2459e0042ea24258c9dc2115979a598"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/cb/67/94c6730ee4c34505b14d94040e2f31edf144c230b6b49e971b4f25ff8fab/s3transfer-0.10.2.tar.gz"
    sha256 "0711534e9356d3cc692fdde846b4a1e4b0cb6519971860796e6bc4c7aea00ef6"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/32/c0/5b8013b5a812701c72e3b1e2b378edaa6514d06bee6704a5ab0d7fa52931/setuptools-71.1.0.tar.gz"
    sha256 "032d42ee9fb536e33087fb66cac5f840eb9391ed05637b3f2a76a7c8fb477936"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "MEDIUM - No resources match for the given action -  - [{'action': 's3:GetObject', " \
                 "'required_format': 'arn:*:s3:::*/*'}] - {'line': 1, 'column': 40, 'filepath': None}",
    pipe_output("#{bin}/parliament --string '{\"Version\": \"2012-10-17\", \"Statement\": {\"Effect\": \"Allow\", " \
                "\"Action\": \"s3:GetObject\", \"Resource\": \"arn:aws:s3:::secretbucket\"}}'").strip
  end
end
