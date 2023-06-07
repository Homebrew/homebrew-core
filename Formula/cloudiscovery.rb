class Cloudiscovery < Formula
  include Language::Python::Virtualenv

  desc "Help you discover resources in the cloud environment"
  homepage "https://github.com/Cloud-Architects/cloudiscovery"
  url "https://files.pythonhosted.org/packages/d3/c2/9a5f93ac5376f83903c8550bde45e2888da3fb092b63e02e19d6c852134c/cloudiscovery-2.4.4.tar.gz"
  sha256 "1170ea352a3c7d5643652ebe96b068482734cd995b9c92dc820206f1b87407e5"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73d5840db5ac1ec0fccd5be7680e3057aa0d70d06c1f84e0c172175527d836fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ef79edc6e888965160451f43b0302215fa803757b33339a271798185a599b99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01d9470ba205b1de5b4149eb7cb2a636b0e52b8129b6fdae85c7e559e5bc5707"
    sha256 cellar: :any_skip_relocation, ventura:        "718c552503df45b02994f3d96d56f37c52e41627463cb08b15b64adbbf096b6e"
    sha256 cellar: :any_skip_relocation, monterey:       "af2a5e29595010b8b7410ca110da562900dfea8932ba56873fe7224f914c0666"
    sha256 cellar: :any_skip_relocation, big_sur:        "aec275f119f6ceb6093eb2bd27832ea6ebd25ffa26fcf5766ac5bc625f0abcd9"
    sha256 cellar: :any_skip_relocation, catalina:       "bd6f1255f9f95402ed607c49e352189854a884260585b710aa84b9c9e6e5bb85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dc9f4285ac4cc7fbf319e131830b0ea704e83781f13c2a77e829100366a5a67"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/db/09/8ac167664014a49131abcc67b5977d7ea0e896f8b00a42f1ef829575798b/boto3-1.26.5.tar.gz"
    sha256 "cb4eca34b6e13e4ead46a68f66759feaae6bf5e97362b2c979b7b9f1d203715e"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/4c/87/62c37750ca4c03d2d3fce2e3de2e13d635576fa74cd0e693fcdf7cbf6db4/botocore-1.29.5.tar.gz"
    sha256 "8a1a074bce7567576947869d41026c45d507e00885f3890c1719180a9400ec40"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/c2/6f/278225c5a070a18a76f85db5f1238f66476579fa9b04cda3722331dcc90f/cachetools-5.2.0.tar.gz"
    sha256 "6a94c6402995a99c3970cc7e4884bb60b4a8639938157eeed436098bf9831757"
  end

  resource "diagrams" do
    url "https://files.pythonhosted.org/packages/96/38/62f2a80fc10441763b7fef93a21d1e029804aefa73fd848fbcb67bd9e125/diagrams-0.23.1.tar.gz"
    sha256 "56230633ee70106ecea38b82dc447084a114055feddda6dc18d1faa1b96f0049"
  end

  resource "diskcache" do
    url "https://files.pythonhosted.org/packages/c7/34/d23a9bc5b2a84917879b977f00fdb97a7700b186a32bf7b0cf5f29f4c2d9/diskcache-5.4.0.tar.gz"
    sha256 "8879eb8c9b4a2509a5e633d2008634fb2b0b35c2b36192d89655dbde02419644"
  end

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/c9/0a/f196d01638f61e1ea27d90ed6874001f9c2fb7dd6281102e4555225a8ae5/graphviz-0.19.2.zip"
    sha256 "7c90cebc147c18bcdffcd3c76db58cbface5d45fe0247a2f3bfb144d32a8c77c"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/b9/9a/3e9da40ea28b8210dd6504d3fe9fe7e013b62bf45902b458d1cdc3c34ed9/ipaddress-1.0.23.tar.gz"
    sha256 "b7f8e0369580bb4a24d5ba1d7cc29660a4a6987763faf1d8a8046830e020e7e2"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7/Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/76/63/1be349ff0a44e4795d9712cc0b2d806f5e063d4d34631b71b832fac715a8/pytz-2022.6.tar.gz"
    sha256 "e89512406b793ca39f5971bc999cc538ce125c0e51c27941bef4568b460095e2"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "{aws-vpc,aws-iot,aws-policy,aws-all,aws-limit,aws-security}",
      shell_output(bin/"cloudiscovery --help 2>&1")

    assert_match "Neither region parameter nor region config were passed",
      shell_output(bin/"cloudiscovery aws-vpc --vpc-id vpc-123 2>&1")
  end
end
