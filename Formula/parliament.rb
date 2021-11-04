class Parliament < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM linting library"
  homepage "https://github.com/duo-labs/parliament"
  url "https://files.pythonhosted.org/packages/64/9a/a5c9a9659131e855f1e93257accf3ea1a7921af71ab42ecb11c76ce8f22a/parliament-1.5.0.tar.gz"
  sha256 "97527eed203241a2ab4702929da42d60dbd1c95eb9f51634f2fd6b5e8824d511"
  license "BSD-3-Clause"
  head "https://github.com/duo-labs/parliament.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cf609371160257a10ce22f1434fe735996b5c100428db67a2e16fbb0953237f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "762b08b94a0f957235b731f9336e6d056ddf4feb83b78c301b50167eb9c1a36a"
    sha256 cellar: :any_skip_relocation, monterey:       "889850472012942199489568ff186ca218a83b85f267d0bd6f6f868319a9b8ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "1286d570bc5ac9ab3f58bc85e09ac8a32037324051ef94d241aaabc2d1dc09dc"
    sha256 cellar: :any_skip_relocation, catalina:       "a91474384d6b34cc0da2ed8bfff122f42a7681735b11f126e3c0599458676b51"
    sha256 cellar: :any_skip_relocation, mojave:         "c2ee834ce7f9c285e06951874cf79fa5d6b025d94f12dc4b4331d2657944615c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9e92e0da8d144ca3e4f22a465dc696b87d2a793a6161016be0cbb34e2ec1f12"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/81/3a/776194a3af46fa263f4f70757fd8ab41b89b6695d257fe267d33c202d228/boto3-1.19.10.tar.gz"
    sha256 "79c982c5930f989292ca849b0caaa1ffeb9eb9d27c32992c3b2f6736b3b14ad2"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/a1/fa/a433898fe23c380319c1a099e022090098b6d384ad685977e3954d230ea3/botocore-1.22.10.tar.gz"
    sha256 "dffa1e7e7e3a8da73bbdead3aeff7d52fd5a159a1a93b2896ac67b2aa79a461c"
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
