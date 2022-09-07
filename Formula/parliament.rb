class Parliament < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM linting library"
  homepage "https://github.com/duo-labs/parliament"
  url "https://files.pythonhosted.org/packages/8b/91/fe6ef857eea3a6794883dc5c767dbaf9eeba452b0759ee88659fece0699e/parliament-1.6.1.tar.gz"
  sha256 "39c854dcf5c35c02366cfea531078f585bd6a6183248f792874588c8c48feca3"
  license "BSD-3-Clause"
  head "https://github.com/duo-labs/parliament.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb36eb1c68e745a346c71e1635103c24116dd90e46959b5cadf534c908681977"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df5abbdf47aedd8de51a75db61e3c898872b00acede5ae3aac382515b440fd59"
    sha256 cellar: :any_skip_relocation, monterey:       "684a7d9a00aed48b87d751b43984fd340d7ae16c428d10ee9b431fdcd9b30377"
    sha256 cellar: :any_skip_relocation, big_sur:        "78acaa13b5dcfd22f7a30a66dd84c9edb26a12ba2f0d1dd21d10762489f0eeab"
    sha256 cellar: :any_skip_relocation, catalina:       "4c54f70b2ca7d85e9446ae1801f3142cc56ae7dde40c1da301b191a28f13d52f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa4358e608a4fedb092cea8ffb6d632c67dce769709ea34ceed219aee9a2eded"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/af/88/0aa54a60d9627bef23b9fe7c3f76c4761064d5f331edd92a2071e4cba358/boto3-1.24.67.tar.gz"
    sha256 "2b9309a98fd7264788ff1d1b19146406cc4191e53ed9a03aca03e8837303fae2"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/57/60/e307245349b8914d423064f53dca3f8a81dac6a7fe69972797067a909314/botocore-1.27.67.tar.gz"
    sha256 "b00894d2eee8a795ecedf9f4cbc454fa449a7bb11af1390c7414755243f90610"
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
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
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
    assert_equal "MEDIUM - No resources match for the given action -  - [{'action': 's3:GetObject', " \
                 "'required_format': 'arn:*:s3:::*/*'}] - {'line': 1, 'column': 40, 'filepath': None}", \
    pipe_output("#{bin}/parliament --string \'{\"Version\": \"2012-10-17\", \"Statement\": {\"Effect\": \"Allow\", " \
                "\"Action\": \"s3:GetObject\", \"Resource\": \"arn:aws:s3:::secretbucket\"}}\'").strip
  end
end
