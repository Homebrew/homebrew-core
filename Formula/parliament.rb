class Parliament < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM linting library"
  homepage "https://github.com/duo-labs/parliament"
  url "https://files.pythonhosted.org/packages/ca/61/006a39b26dfaa909a6b0dda45b7f9df41e9d3be90517da7b1163b5d28377/parliament-1.5.2.tar.gz"
  sha256 "80945a97715d1cfd736978727896ef8d39328fa6edc88be248116660309cf799"
  license "BSD-3-Clause"
  head "https://github.com/duo-labs/parliament.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "333d2e3d3efdf8b87f9c0fe9fa2d03081256afad546880b459123e00aa4d1f6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5323fb61cea69c3c06af5b6b65e7e3176b724b4c0feb603fd1797a681ef9a042"
    sha256 cellar: :any_skip_relocation, monterey:       "3ec93ebd9de4c765ffdca0d96fd3d8bdf7df372ea4eb4e073d5f416153d5c8c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0adaa6db71638d44fdc5879feb17e748a0bba14138b61804e32cdf52e74ac3ef"
    sha256 cellar: :any_skip_relocation, catalina:       "82a8834f0e2692caa13738729dbf6f476a494ddb065e416c65d224523bed661f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d68a0e002aeb5bd42edd23fb04247a6567926b1bc5356c65168d11929e323d2e"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/6d/27/5a5e2c3048d83dcbbd89167810e59d67035bdcb5e2aa2453b8f171e12c27/boto3-1.20.0.tar.gz"
    sha256 "17b942d9513f396b2e90f71131b48cdc49279c9714189bbf84a232d189a793dd"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/28/e4/202d80d8f891949537ca83398ff5586068c6ab515bdaac85936169578309/botocore-1.23.1.tar.gz"
    sha256 "3daa7148017685ee8120c12b024ad2b6eadc1abc775627d4f4dd8182aaca5d0f"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
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
    url "https://files.pythonhosted.org/packages/88/ef/4d1b3f52ae20a7e72151fde5c9f254cd83f8a49047351f34006e517e1655/s3transfer-0.5.0.tar.gz"
    sha256 "50ed823e1dc5868ad40c8dc92072f757aa0e653a192845c94a3b676f4a62da4c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "MEDIUM - No resources match for the given action -  - [{'action': 's3:GetObject',"\
                 " 'required_format': 'arn:*:s3:::*/*'}] - {'line': 1, 'column': 40, 'filepath': None}", \
    pipe_output("#{bin}/parliament --string \'{\"Version\": \"2012-10-17\", \"Statement\": {\"Effect\": \"Allow\","\
                " \"Action\": \"s3:GetObject\", \"Resource\": \"arn:aws:s3:::secretbucket\"}}\'").strip
  end
end
